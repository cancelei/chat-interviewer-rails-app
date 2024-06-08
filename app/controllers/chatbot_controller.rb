# app/controllers/chatbot_controller.rb
class ChatbotController < ApplicationController
  def respond
    message = params[:message]
    ChatbotResponseJob.perform_later(message)
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.append('messages', partial: 'message', locals: { message: message }) }
      format.html { redirect_to root_path }
    end
  end
end
