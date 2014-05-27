# encoding: utf-8
require File.expand_path('../config/application', __FILE__)

module RunMyGist
  class API < BaseAPI
    respond_to :json

    # curl 0.0.0.0:9292/
    # => {"hello":"world"}
    get do
      { hello: 'world' }
    end

    # Mount your other APIs here
    # mount UsersAPI => :users
  end
end

# Your crêpe is ready.
run RunMyGist::API
