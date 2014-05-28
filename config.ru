# encoding: utf-8
require File.expand_path('../config/application', __FILE__)
require 'docker'

module RunMyGist
  class API < BaseAPI
    extend Crepe::Streaming
    respond_to :text

    stream(:gist) do
      container = Docker::Container.create('Cmd' => ['ruby', '-v'], 'Image' => 'litaio/ruby')
      container.tap(&:start).attach { |stream, chunk| render chunk }
      container.delete(:force => true)
    end
  end
end

# Your crêpe is ready.
run RunMyGist::API
