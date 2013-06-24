require 'sinatra/base'
require_relative 'lib/models/student.rb'

# Why is it a good idea to wrap our App class in a module?
module StudentSite
  class App < Sinatra::Base

    def initialize
      super
      @artists = ["Frank Sinatra", "Bing Crosby", "Bob\n\n\n\n", 1, 2, "dslajkffoiejfijasdlfl"]
    end

    def set_random_numbers(arg)
      @random_numbers = arg
    end

    get '/' do
      "hello world!"
    end

    get '/hello-world' do
      set_random_numbers((1..20).to_a)
      p @random_numbers
      erb :hello
    end

    get '/artists' do
      erb :artists
    end

  end
end