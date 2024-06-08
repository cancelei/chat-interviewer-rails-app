class ChatbotController < ApplicationController
  def respond
    message = params[:message]
    ChatbotResponseJob.perform_later(message)
    render turbo_stream: turbo_stream.append('messages', partial: 'message', locals: { message: message })
  end
end
