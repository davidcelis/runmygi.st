# encoding: utf-8
require File.expand_path('../config/application', __FILE__)
require 'fileutils'
require 'octokit'

module RunMyGist
  class API < BaseAPI
    extend Crepe::Streaming
    respond_to :text

    param :username do
      param :id do
        stream do
          copy_gist!

          create_entry_script!

          image     = Docker::Image.build_from_dir(gist_path, 'rm' => true)
          container = Docker::Container.create('Image' => image.id)

          # Containers will time out after 60 seconds by default
          container.tap(&:start).attach { |stream, chunk| render chunk }

          container.delete(force: true)
          image.delete(force: true)

          FileUtils.rm_rf(gist_path)
        end
      end
    end
  end
end

# Your crêpe is ready.
run RunMyGist::API
