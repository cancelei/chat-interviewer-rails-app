class OpenAiService
  def initialize
    @client = OpenAI::Client.new(api_key: ENV['OPENAI_API_KEY'])
  end

  def get_response(message)
    response = @client.completions(
      engine: "text-davinci-003",
      parameters: {
        prompt: message,
        max_tokens: 30
      }
    )
    response.dig("choices", 0, "text").strip
  end
end
