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

          script = "#!/bin/bash"

          # Write each file into the temporary directory
          files.each do |_, file|
            filepath = "#{gist_path}/#{file[:filename]}"

            case file[:language]
            when 'Ruby'
              script += %(\nruby /tmp/#{file[:filename]})
            when 'Python'
              script += %(\npython /tmp/#{file[:filename]})
            when 'Java'
              script += %(\ncd /tmp/ && javac #{file[:filename]})
              script += %(\njava #{file[:filename].gsub('.java', '')})
              script += %(\ncd -)
            when 'JavaScript'
              script += %(\nnode /tmp/#{file[:filename]})
            end

            File.open(filepath, 'w') { |f| f.write(file[:content]) }
          end

          # Copy a Dockerfile into it
          FileUtils.cp('lib/Dockerfile', gist_path)

          filepath = "#{gist_path}/runmygi.st"
          File.open(filepath, 'w') { |f| f.write(script) }
          FileUtils.chmod 0755, filepath

          # Build an image
          image = Docker::Image.build_from_dir(gist_path)

          # Create a container
          container = Docker::Container.create('Image' => image.id)

          # Run it
          container.tap(&:start).attach { |stream, chunk| render chunk }
          container.wait(60)

          # Delete it
          container.delete(force: true)

          # Remove temporary directory
          FileUtils.rm_rf(gist_path)
        end
      end
    end
  end
end

# Your crêpe is ready.
run RunMyGist::API
