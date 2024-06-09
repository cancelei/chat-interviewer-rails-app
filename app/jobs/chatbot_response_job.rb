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

    if applicant.status == 0  # If status is 0, use OpenAI to respond
      if message.downcase.include?("não") || message.downcase.include?("no")
        applicant.update(status: 1)  # Change status if the user says "no"
      end
      response = openai_service.get_response(message)
      Rails.logger.info "Chatbot response: #{response}"
      ActionCable.server.broadcast("chat_channel", { message: render_message(response) })
      if message.downcase.include?("não") || message.downcase.include?("no")
        applicant.update(status: 1)  # Change status if the user says "no"
      end
    else  # If status is 1, ask the next preformatted question
      next_question_index = applicant.responses.count
      if next_question_index < QUESTIONS.length
        next_question = QUESTIONS[next_question_index]
        applicant.responses.create(content: message)  # Store the user's message
        ActionCable.server.broadcast("chat_channel", { message: render_message(next_question) })
      else
        # Reset status to 0 for any further OpenAI related responses
        applicant.update(status: 0)
      end
    end
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(partial: 'chatbot/message', locals: { message: message })
  end
end
