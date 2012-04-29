require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'

enable :sessions

configure do
  db = URI.parse(ENV['DATABASE_URL'] || 'sqlite://development.db')

  options = {
    :adapter => db.scheme,
    :host => db.host,
    :port => db.port,
    :database => db.path[1..-1],
    :username => db.user,
    :password => db.password
  }
  case db.scheme
  when "sqlite"
    options[:adapter] = "sqlite3"
    options[:database] = db.host
  when "postgres"
    options[:adapter] = "postgresql"
  end

  ActiveRecord::Base.establish_connection(options)
end

class Activity < ActiveRecord::Base
  has_many :participants
  validates :description, :presence => true
  
  def pcount
    self.participants.size
  end
  
  def plist
    self.participants.map { |p| p.nickname }.join ', ' 
  end
  
  def author_nickname
    begin
      n = Participant.find_by_ipaddress(self.author_ipaddress).nickname
    rescue
      n = "Incognito"
    end
  end
end

class Participant < ActiveRecord::Base
  belongs_to :activity
  validates :activity_id, :numericality => true
end

class AugmentedActivity
  attr_reader :id, :description, :plist, :pcount, :author_nickname
  
  def initialize(id, description, plist, pcount, author_nickname)
    @id = id
    @description = description
    @plist = plist
    @pcount = pcount
    @author_nickname = author_nickname
  end
end

before do
	session[:ux] = "d" unless session[:ux] == "m"
  p = Participant.find_by_ipaddress(request.ip)
  if p.nil?
    Participant.create(:ipaddress => request.ip, :nickname => request.ip, :activity_id => 0 )
  end
end

def collect_data
  @activities = Activity.all
  @augmented_activities = []
  @activities.each do |a|
    @augmented_activities << AugmentedActivity.new(a.id, a.description, a.plist, a.pcount, a.author_nickname)
  end
  @augmented_activities.sort! { |x,y| y.pcount <=> x.pcount }
  @allow_add_activity = false
  a = Activity.find_by_author_ipaddress(request.ip)
  if a.nil?
    @allow_add_activity = true
  end
  @prompt_for_nickname = false
  participant = Participant.find_by_ipaddress(request.ip)
  if participant.ipaddress == participant.nickname
    @prompt_for_nickname = true
  end
  @activity_id_of_current_user = Participant.find_by_ipaddress(request.ip).activity_id
end

get '/' do
	if session[:ux] == "d"
		redirect '/d/'
	end
	if session[:ux] == "m"
		redirect '/m/'
	end
end

get '/d/' do
	session[:ux] = "d"
	collect_data
	erb :index_d
end

get '/m/' do
	session[:ux] = "m"
	collect_data
	erb :index_m
end

get '/d/admin/' do
  @activities = Activity.all
  erb :admin_d
end

post '/doaddactivity' do
  a = Activity.create(:author_ipaddress => request.ip, :description => params[:activity][:description])
  p = Participant.find_by_ipaddress(request.ip)
  p.activity_id = a.id
  p.save
  redirect '/'
end

post '/dosetpreference/:id' do
  p = Participant.find_by_ipaddress(request.ip)
  p.activity_id = params[:id].to_i
  p.save
  redirect '/'
end

post '/dodeleteactivity/:id' do
  a = Activity.find(params[:id].to_i)
  a.destroy
  redirect '/d/admin/'
end

post '/dochangenickname' do
  participant = Participant.find_by_ipaddress(request.ip)
  participant.nickname = params[:participant][:nickname]
  participant.save
  redirect '/'
end

get "/d/seedwithdata/" do
  Activity.create(:author_ipaddress => "8.1.1.33", :description => "Mergem la un laser tag")
  Activity.create(:author_ipaddress => "8.1.1.20", :description => "Mergem la o cafenea jazzy")
  Activity.create(:author_ipaddress => "8.1.1.23", :description => "Mergem la mall")
  Activity.create(:author_ipaddress => "8.1.1.27", :description => "Mergem in club")
  Activity.create(:author_ipaddress => "8.1.1.12", :description => "Mergem la concert")
  Activity.create(:author_ipaddress => "8.1.1.29", :description => "Mergem la film")
  Activity.create(:author_ipaddress => "8.1.1.26", :description => "Mergem la o pizzerie")
  Participant.create(:ipaddress => "8.1.1.10", :nickname => "AquaShark", :activity_id => 1)
  Participant.create(:ipaddress => "8.1.1.11", :nickname => "EtherealCereal", :activity_id => 1)
  Participant.create(:ipaddress => "8.1.1.12", :nickname => "KellyPenguinGRRRL", :activity_id => 1)
  Participant.create(:ipaddress => "8.1.1.13", :nickname => "Frodo", :activity_id => 6)
  Participant.create(:ipaddress => "8.1.1.14", :nickname => "WeaponX", :activity_id => 1)
  Participant.create(:ipaddress => "8.1.1.15", :nickname => "AgentSmith", :activity_id => 1)
  Participant.create(:ipaddress => "8.1.1.16", :nickname => "WonderWoman", :activity_id => 5)
  Participant.create(:ipaddress => "8.1.1.17", :nickname => "XenaWarriorPrincess", :activity_id => 5)
  Participant.create(:ipaddress => "8.1.1.18", :nickname => "ChuckNorris", :activity_id => 1)
  Participant.create(:ipaddress => "8.1.1.19", :nickname => "PrincessLeia", :activity_id => 1)
  Participant.create(:ipaddress => "8.1.1.20", :nickname => "LifeEnigma", :activity_id => 5)
  Participant.create(:ipaddress => "8.1.1.21", :nickname => "GossipGRRRL", :activity_id => 5)
  Participant.create(:ipaddress => "8.1.1.22", :nickname => "1337H4XX0R", :activity_id => 1)
  Participant.create(:ipaddress => "8.1.1.23", :nickname => "RoseLeaf", :activity_id => 4)
  Participant.create(:ipaddress => "8.1.1.24", :nickname => "ShinyPearl", :activity_id => 4)
  Participant.create(:ipaddress => "8.1.1.25", :nickname => "HappyAngelOfSnow", :activity_id => 4)
  Participant.create(:ipaddress => "8.1.1.26", :nickname => "BlackSwan", :activity_id => 5)
  Participant.create(:ipaddress => "8.1.1.27", :nickname => "FreeStyler", :activity_id => 1)
  Participant.create(:ipaddress => "8.1.1.28", :nickname => "SugarCoated", :activity_id => 5)
  Participant.create(:ipaddress => "8.1.1.29", :nickname => "Principessa", :activity_id => 6)
  Participant.create(:ipaddress => "8.1.1.30", :nickname => "DarthCoder", :activity_id => 1)
  Participant.create(:ipaddress => "8.1.1.31", :nickname => "Haiducul", :activity_id => 1)
  Participant.create(:ipaddress => "8.1.1.32", :nickname => "ManOnTheRun", :activity_id => 1)
  Participant.create(:ipaddress => "8.1.1.33", :nickname => "Ronaldinho", :activity_id => 1)
  Participant.create(:ipaddress => "8.1.1.34", :nickname => "Juventus", :activity_id => 1)
  Participant.create(:ipaddress => "8.1.1.35", :nickname => "Scorpion", :activity_id => 1)
  redirect "/"
end

