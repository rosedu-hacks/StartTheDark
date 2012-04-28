require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'

class Activity < ActiveRecord::Base
end

class Participants < ActiveRecord::Base
end

before do
	rqip = request.ip
#	Participants.find_by
end

get '/' do
	@activities = Activity.all
	erb :index_d
end

