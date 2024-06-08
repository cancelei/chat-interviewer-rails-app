# app/services/open_ai_service.rb
require 'dotenv/load'
require 'openai'

class OpenAiService
  def initialize
    @client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'],
    log_errors: true)
  end

  def get_response(message)
    response = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [
          { role: 'system', content: 'You are a helpful assistant.' },
          { role: "user", content: message }
        ]
      }
    )
    Rails.logger.info "OpenAI API response: #{response.inspect}"
    response.dig("choices", 0, "message", "content")
    rescue StandardError => e
      Rails.logger.error "OpenAI API call failed: #{e.message}"
      "Failed to get a response from OpenAI"
    end
end
