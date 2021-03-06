require 'fileutils'
require 'octokit'

module ApplicationHelper
  def clone_gist!
    FileUtils.mkdir_p(gist_path)

    # Write each file into the temporary directory
    gist.files.each do |_, file|
      filepath = "#{gist_path}/#{file[:filename]}"
      File.open(filepath, 'w') { |f| f.write(file[:content]) }
    end

    File.open("#{gist_path}/Dockerfile", 'w') { |f| f.write(dockerfile) }

    create_entry_script!
  end

  def delete_gist!
    FileUtils.rm_rf(gist_path)
  end

  def create_entry_script!
    filepath = "#{gist_path}/runmygi.st"

    unless File.exists?(filepath)
      script = File.open(filepath, 'w')
      script.puts "#!/bin/bash\n"

      gist.files.each do |_, file|
        case file[:language]
        when 'Ruby'
          script.puts "ruby /tmp/#{file[:filename]}"
        when 'Python'
          script.puts "python /tmp/#{file[:filename]}"
        when 'Java'
          script.puts "cd /tmp/ && javac #{file[:filename]}"
          script.puts "java #{file[:filename].gsub('.java', '')}"
          script.puts "cd - > /dev/null 2>&1"
        when 'JavaScript'
          script.puts "node /tmp/#{file[:filename]}"
        end
      end

      script.close
    end

    FileUtils.chmod(0755, filepath)
  end

  def dockerized
    image     = Docker::Image.build_from_dir(gist_path, 'rm' => true)
    container = Docker::Container.create('Image' => image.id)

    yield container.tap(&:start)
  ensure
    container.delete(force: true)
    image.delete(force: true)
  end

  private

  def dockerfile
    <<-DOCKERFILE.gsub(/^ {6}/, '')
      FROM davidcelis/runmygi.st:latest

      ADD . /tmp/

      CMD ["/tmp/runmygi.st"]
    DOCKERFILE
  end

  def gist_path
    Crepe.root.join('tmp', params[:username], params[:id])
  end

  def gist
    @gist ||= begin
      endpoint = request.headers['GitHub-URL'] if request.headers['GitHub-URL']
      token    = request.headers['Authorization'].sub(/token /i, '') if request.headers['Authorization']
      Gist.new(params[:id], github_url: endpoint, access_token: token)
    end
  end
end
