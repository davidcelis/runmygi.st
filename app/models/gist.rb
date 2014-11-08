class Gist
  attr_reader :files

  def initialize(id)
    @gist = Octokit::Client.new.gist(id)
    @files = @gist[:files].to_h
  end
end
