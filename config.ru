require File.expand_path('../config/application', __FILE__)

module RunMyGist
  class API < BaseAPI
    extend Crepe::Streaming
    respond_to :text

    rescue_from Octokit::NotFound do |e|
      render "Error: gist not found"
    end

    rescue_from Faraday::TimeoutError, Faraday::ConnectionFailed do |e|
      render "Error: unable to communicate with GitHub"
    end

    param :username do
      param :id do
        stream do
          clone_gist!

          dockerized do |container|
            container.attach { |_, chunk| render chunk }
          end

          delete_gist!
        end
      end
    end
  end
end

run RunMyGist::API
