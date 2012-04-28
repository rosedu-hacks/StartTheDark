require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'

class Activity < ActiveRecord::Base
end

class Participants < ActiveRecord::Base
end

get '/' do
  erb :index_d
end

