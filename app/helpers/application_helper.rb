module ApplicationHelper
  def dockerfile
    <<-DOCKERFILE.gsub(/^ {6}/, '')
      FROM davidcelis/runmygi.st:latest

      ADD . /tmp/

      CMD ["/tmp/runmygi.st"]
    DOCKERFILE
  end
end
