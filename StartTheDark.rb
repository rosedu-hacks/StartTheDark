require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'

class Activity < ActiveRecord::Base
end

class Participants < ActiveRecord::Base
end

before do
  p "debug before filter"
  p request.ip
  #Participants
end

get '/' do
  @activities = Activity.all
  erb :index_d
end

