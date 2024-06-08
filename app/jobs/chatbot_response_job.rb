# app/jobs/chatbot_response_job.rb
class ChatbotResponseJob < ApplicationJob
  queue_as :default

  def perform(message)
    openai_service = OpenAiService.new
    response = openai_service.get_response(message.content)

    if response.present?
      message.update(response: response)
      # Broadcast the response to the chat channel
      ActionCable.server.broadcast "chat_channel", message: render_message(message)
    else
      Rails.logger.error "Failed to get a response from OpenAI"
    end
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message })
  end
end
