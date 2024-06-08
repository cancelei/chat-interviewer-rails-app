class ChatbotController < ApplicationController

  def index
    # Render the chat interface
  end

  def respond
    user_message = params[:message]
    ChatbotResponseJob.perform_later(user_message)
    # Immediately render an acknowledgment response
    render turbo_stream: turbo_stream.append("messages", partial: "chatbot/message", locals: { message: "Processing your request..." })
  end
end
