# encoding: utf-8
require File.expand_path('../config/application', __FILE__)
require 'fileutils'
require 'octokit'
require 'docker'

module RunMyGist
  class API < BaseAPI
    extend Crepe::Streaming
    respond_to :text

    param :username do
      param :id do
        stream do
          # Create a temporary directory
          gist_path = File.expand_path("../tmp/#{params[:username]}/#{params[:id]}", __FILE__)
          FileUtils.mkdir_p(gist_path)

          # Pull Gist info from API
          gist = Octokit::Client.new.gist(params[:id])
          files = gist[:files].to_h

          dockerfile = <<-DOCKERFILE
            FROM litaio/ruby
            ADD . /tmp/

            CMD ["/tmp/runmygi.st"]
          DOCKERFILE

          script = "#!/bin/bash"

          # Write each file into the temporary directory
          files.each do |_, file|
            filepath = "#{gist_path}/#{file[:filename]}"
            script += %(\nruby /tmp/#{file[:filename]})
            File.open(filepath, 'w') { |f| f.write(file[:content]) }
          end

          # Copy a Dockerfile into it
          filepath = "#{gist_path}/Dockerfile"
          File.open(filepath, 'w') { |f| f.write(dockerfile) }

          filepath = "#{gist_path}/runmygi.st"
          File.open(filepath, 'w') { |f| f.write(script) }
          FileUtils.chmod 0755, filepath

          # Build an image

          # Create a container

          # Run it

          # Kill it

          # Remove temporary directory
          
        end
      end
    end
  end
end

# Your crêpe is ready.
run RunMyGist::API
