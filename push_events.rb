require 'rubygems'
require 'bundler/setup'
require 'nokogiri'
require 'yaml'

require 'trollop'

require 'viewpoint'
include Viewpoint::EWS

opts = Trollop::options do
    synopsis "A script to push events from EWS to Pushover"
    opt :config, "Name of configuration file", :default=>"config.yml"
    opt :minutes, "Number of minutes to look ahead for events", :type => :int, :default => 30   # integer 
end

config = YAML.load_file(opts[:config])

endpoint = config["ews"]["endpoint"]
user = config["ews"]["user"]
pass = config["ews"]["pass"]

cli = Viewpoint::EWSClient.new endpoint, user, pass, server_version: SOAP::ExchangeWebService::VERSION_2007_SP1

# see https://github.com/WinRb/Viewpoint/issues/184


start_date = Time.now.to_datetime
end_date = (Time.now + 60*opts[:minutes]).to_datetime

p start_date
p end_date

#calendar = cli.get_folder(:calendar)
#items = calendar.items_between sd, ed

events = cli.find_items({:folder_id => :calendar, :calendar_view => {:start_date => start_date, :end_date => end_date}})

events.each do |event|

  p event.subject
  puts "#{event.start} - #{event.end}\t #{event.subject}"
end

# see http://answer.io/p/ddacunha/Viewpoint

