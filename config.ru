# encoding: utf-8
require File.expand_path('../config/application', __FILE__)

module RunMyGist
  class API < BaseAPI
    extend Crepe::Streaming
    respond_to :text

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

    rescue_from Octokit::NotFound do |e|
      error! :not_found, e.message
    end
  end
end

# Your crêpe is ready.
run RunMyGist::API
