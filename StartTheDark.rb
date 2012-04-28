require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'

enable :sessions

class Activity < ActiveRecord::Base
  has_many :participants
  validates :description, :presence => true
end

class Participant < ActiveRecord::Base
  belongs_to :activity
  validates :activity_id, :numericality => true
end

before do
  p "debug before filter"
  p request.ip
  p = Participant.find_by_ipaddress(request.ip)
  if p.nil?
    Participant.create(:ipaddress => request.ip, :nickname => request.ip, :activity_id => 0 )
  end
end

get '/' do
  @activities = Activity.all
  @allow_add_activity = false
  a = Activity.find_by_author_ipaddress(request.ip)
  if a.nil?
    @allow_add_activity = true
  end
  erb :index_d
end

post '/doaddactivity' do
  a = Activity.create(:author_ipaddress => request.ip, :description => params[:activity][:description])
  p = Participant.find_by_ipaddress(request.ip)
  p.activity_id = a.id
  p.save
  redirect '/'
end
