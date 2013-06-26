require 'sinatra/base'
require 'sqlite3'
require 'shotgun'
require 'debugger'
require_relative 'lib/concerns/persistable'
require_relative 'lib/concerns/findable'

require_relative 'lib/models/student'

# Why is it a good idea to wrap our App class in a module?
module StudentSite
  class App < Sinatra::Base

    get '/' do
      @students = Student.all
      erb :'students/students'
    end

    get '/students/new' do
      erb :'students/new'
    end

    post '/students' do
      new_dude = Student.new
      new_dude.name = params[:name]
      new_dude.tagline = params[:tagline]
      new_dude.bio = params[:bio]
      new_dude.twitter = params[:twitter]
      new_dude.save
      @students = Student.all      
      erb :'students/students'
    end

    get '/students/:id/edit' do
      @student = Student.find_by_id(params[:id])
      erb :'students/edit'
    end

    post '/students/:id' do
      @student = Student.find_by_id(params[:id])
      @student.name = params[:name]
      # new_dude.tagline = params[:tagline]
      # new_dude.bio = params[:bio]
      # new_dude.twitter = params[:twitter]
      @student.save
      erb :'students/student_profile'
    end

    get '/students' do
      @students = Student.all
      erb :'students/students'
    end

    get '/students/:id' do
      # @students = Student.all
      @student = Student.find_by_id(params[:id])
      erb :'students/student_profile'
    end
  end
end

# get '/students/1/edit' to display a 
# form to edit a student



