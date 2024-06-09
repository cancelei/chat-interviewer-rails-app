# app/services/open_ai_service.rb
require 'dotenv/load'
require 'openai'

class OpenAiService
  JOB_DESC = "Job Opportunity at Plaza: Key Information
    Company Overview:

    Name: Plaza
    Industry: Proptech/Fintech
    Location: São Paulo, Brazil
    Growth: 34% monthly
    Backing: VC-funded
    Role Overview:

    Position: Software Developer (Founding Team Member)
    Environment: On-site with occasional remote work
    Tech Stack: Ruby on Rails, heavy use of OpenAI's API
    Responsibilities:

    Deliver value beyond coding; engage with stakeholders (founders, clients, team members)
    Contribute to the company's growth by questioning and validating the need for solutions
    Build and iterate products quickly, focusing on client feedback
    Expectations:

    Participate in building the company, not just writing software
    Communicate effectively, forming strong connections with colleagues
    Contribute to a fun, collaborative working environment
    Technical Skills:

    Experience: Minimum 5 years in software development
    Position Level: Senior/Staff/Leadership in a tech-driven company
    Skillset: Expert generalist (front-end, back-end, databases, various programming languages)
    Pluses: Experience with GenAI/ML
    Compensation:

    Competitive salary
    Aggressive stock options plan
    Ideal Candidate:

    Passionate about building from scratch and tackling loosely defined problems
    Interested in understanding and participating in product development
    Lifelong learner, eager for new challenges
    Understands the purpose of software beyond coding
    Proposes changes to make projects more viable or cost-effective
    Communicative, able to simplify complex topics
    Willing to invest time in building something significant for career growth
    Summary:
    If you want to make a difference, work on innovative projects, and grow both professionally and personally while being a key player in a fast-growing company, Plaza is looking for you. Join us in São Paulo, where you will be part of an exciting journey to revolutionize the real estate market with cutting-edge technology and AI.
  "

  def initialize
    @client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'], log_errors: true)
  end

  def get_response(message)
    response = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [
          { role: 'system', content: "You are a Recruiter called Fernanda. Answer questions using the job description: #{JOB_DESC} after each response, ask if there is any other questions." },
          { role: "user", content: message }
        ],
        max_tokens: 150
      }
    )
    Rails.logger.info "OpenAI API response: #{response.inspect}"
    response.dig("choices", 0, "message", "content")
  rescue StandardError => e
    Rails.logger.error "OpenAI API call failed: #{e.message}"
    "Failed to get a response from OpenAI"
  end
end
