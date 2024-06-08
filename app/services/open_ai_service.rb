# app/services/open_ai_service.rb

class OpenAiService
  def get_response(prompt)
    client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])

    response = client.completions(
      model: 'text-davinci-003',
      prompt: prompt,
      max_tokens: 150
    )

    response.choices.first.text.strip
  rescue StandardError => e
    Rails.logger.error "OpenAI API call failed: #{e.message}"
    nil
  end
end
