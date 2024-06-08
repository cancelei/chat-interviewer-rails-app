class ChatbotResponseJob < ApplicationJob
  queue_as :default

  def perform(user_message)
    response = OpenAiService.new.get_response(user_message)
    # Here you can handle the response, such as saving it to the database
    # or broadcasting it to a Turbo Stream, etc.
    ActionCable.server.broadcast "chat_channel", message: response
  end
end
