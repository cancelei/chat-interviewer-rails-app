# app/jobs/chatbot_response_job.rb

class ChatbotResponseJob < ApplicationJob
  queue_as :default

  def perform(message)
    openai_service = OpenAiService.new
    response = openai_service.get_response(message)
    Rails.logger.info "Chatbot response: #{response}"
    ActionCable.server.broadcast("chat_channel", { message: render_message(response) })
  end

  private

  def render_message(response)
    ApplicationController.renderer.render(partial: 'chatbot/message', locals: { message: response })
  end
end
