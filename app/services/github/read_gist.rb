# frozen_string_literal: true

class Github::ReadGist

  ACCESS_TOKEN = Rails.application.credentials.dig(:github, :token)
  GIST_DOMAIN = 'gist.github.com'

  GitHubResponse = Struct.new(:description) do
    def success?
      html_url.present?
    end
  end

  def self.gist_url?(url)
    url.split('/').include?(GIST_DOMAIN)
  end

  attr_reader :id, :client

  def initialize(gist_url, client: nil)
    @id = gist_url.split('/').last
    @client = client || Octokit::Client.new(access_token: ACCESS_TOKEN)
  end

  def call
    response = client.gist(@id)
    GitHubResponse.new(response.description)
  end
end
