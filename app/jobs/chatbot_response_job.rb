class ChatbotResponseJob < ApplicationJob
  queue_as :default

  def perform(user_message)
    response = OpenAiService.new.get_response(user_message)
    # Save response to the database or take any other required action
  end
end
