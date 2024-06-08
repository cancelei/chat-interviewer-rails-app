class ChatbotController < ApplicationController

  def index
    # Render the chat interface
  end

  def respond
    user_message = params[:message]
    response = OpenAiService.new.get_response(user_message)
    # Process response and save to database if needed
    render turbo_stream: turbo_stream.append("chat", partial: "chatbot/message", locals: { message: response })
  end
end
