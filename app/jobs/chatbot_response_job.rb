# app/jobs/chatbot_response_job.rb
class ChatbotResponseJob < ApplicationJob
  queue_as :default

  QUESTIONS = [
    "Perfect. Could you let me know how many years of experience you have?",
    "What is your preferred programming language?",
    "Interesting, and would you be willing to program in Ruby?",
    "Are you also willing to work in-person?",
    "We will schedule an interview with our technical team. How is your availability?",
    "Perfect, I will check the schedule with our team and get back to you shortly. Have a good day!"
  ]

  retry_on StandardError, wait: :polynomially_longer, attempts: 2

  def perform(message)
    applicant = find_or_create_applicant
    if applicant.status.zero? || !message_includes_no(message)
      handle_openai_response(message, applicant)
    else
      handle_next_question(message, applicant)
    end
  rescue StandardError => e
    Rails.logger.error "Error in ChatbotResponseJob for applicant #{applicant.id if applicant}: #{e.message}"
    raise
  end

  private

  def find_or_create_applicant
    Applicant.last || Applicant.create!(status: 0)
  end

  def handle_openai_response(message, applicant)
    response = openai_service.get_response(message)
    Rails.logger.info "Chatbot response for applicant #{applicant.id}: #{response}"
    broadcast_message(response)
  end

  def handle_next_question(message, applicant)
    next_question_index = applicant.responses.count
    if next_question_index < QUESTIONS.length
      next_question = QUESTIONS[next_question_index]
      applicant.responses.create!(content: message)
      broadcast_message(next_question)
    else
      reset_applicant_status(applicant)
    end
  end

  def reset_applicant_status(applicant)
    applicant.update!(status: 0)
  end

  def message_includes_no(message)
    message.downcase.include?("não") || message.downcase.include?("no")
  end

  def broadcast_message(message)
    ActionCable.server.broadcast("chat_channel", { message: render_message(message) })
  end

  def render_message(message)
    ApplicationController.renderer.render(partial: 'chatbot/message', locals: { message: message })
  end

  def openai_service
    @openai_service ||= OpenAiService.new
  end
end
