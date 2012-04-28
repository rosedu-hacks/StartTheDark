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
	Activity.create(:author_ipaddress => request.ip, :description => params[:activity][:description])
	redirect '/'
end
