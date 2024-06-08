class ChatbotResponseJob < ApplicationJob
  queue_as :default

  def perform(message)
    if message.is_a?(Message) # Ensure the message is of the expected type
      openai_service = OpenAiService.new
      response = openai_service.get_response(message.content)

      if response.present?
        message.update(response: response)
        ActionCable.server.broadcast "chat_channel", message: render_message(message)
      else
        Rails.logger.error "Failed to get a response from OpenAI"
      end
    else
      Rails.logger.error "Expected message to be an instance of Message, got #{message.class}"
    end
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message })
  end
end
