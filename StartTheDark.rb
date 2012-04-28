require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'

class Activity < ActiveRecord::Base
end

class Participant < ActiveRecord::Base
end

before do
 	p = Participant.find_by_ipaddress(request.ip)
 	if p.nil?
 		Participant.create(:ipaddress => request.ip,:nickname => request.ip, :activity_id => 0) 
 	end
end

get '/' do
	@activities = Activity.all
	erb :index_d
end

post '/doaddactivity' do
	a = Activity.create(:author_ipaddress => request.ip, :description => params[:activity][:description])
 	p = Participant.find_by_ipaddress(request.ip)
 	p.activity_id = a.id
 	p.save
	redirect '/'
end


