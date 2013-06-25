require 'sinatra/base'
require 'sqlite3'

require_relative 'lib/concerns/persistable'
require_relative 'lib/concerns/findable'

require_relative 'lib/models/student'

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

    get '/students' do
      @students = Student.all
      erb :'students/students'
    end

    get '/students/:url' do
      # @students = Student.all
      @student = Student.find_by_url(params[:url])
      erb :'students/student_profile'
    end
  end
end