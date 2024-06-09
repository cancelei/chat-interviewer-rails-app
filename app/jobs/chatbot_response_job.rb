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

  def perform(message)
    applicant = Applicant.last || Applicant.create(status: 0)
    openai_service = OpenAiService.new

    if message.include?("não") || message.include?("no") || applicant.status == 1
      response = openai_service.get_response(message)
      Rails.logger.info "Chatbot response: #{response}"
      ActionCable.server.broadcast("chat_channel", { message: render_message(response) })
      applicant.update(status: 1)
    else
      response = openai_service.get_response(message)
      Rails.logger.info "Chatbot response: #{response}"
      ActionCable.server.broadcast("chat_channel", { message: render_message(response) })
    end

    # Ask the next question
    next_question_index = applicant.responses.count
    if next_question_index < QUESTIONS.length
      next_question = QUESTIONS[next_question_index]
      applicant.responses.create(content: message)  # Store the user's message
      ActionCable.server.broadcast("chat_channel", { message: render_message(next_question) })
    end
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(partial: 'chatbot/message', locals: { message: message })
  end
end
