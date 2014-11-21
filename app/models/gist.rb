class Gist
  attr_reader :files

  def initialize(id, github_url: 'https://api.github.com', access_token:)
    @gist = Octokit::Client.new(api_endpoint: github_url, access_token: access_token).gist(id)
    @files = @gist[:files].to_h
  end
end
