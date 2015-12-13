#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'nokogiri'
require 'yaml'

require 'trollop'

require 'viewpoint'
include Viewpoint::EWS

require 'pushover'

opts = Trollop::options do
    synopsis "A script to push events from EWS to Pushover"
    opt :config, "Name of configuration file", :default=>"config.yml"
    opt :minutes, "Number of minutes to look ahead for events", :type => :int, :default => 30   # integer 
end

config = YAML.load_file(opts[:config])

endpoint = config["ews"]["endpoint"]
user = config["ews"]["user"]
pass = config["ews"]["pass"]

pushover_user_token = config["pushover"]["user_token"]
pushover_app_token = config["pushover"]["app_token"]
pushover_sound = config["pushover"]["sound"]

Pushover.configure do |config|
  config.user=pushover_user_token
  config.token=pushover_app_token
end

cli = Viewpoint::EWSClient.new endpoint, user, pass, server_version: SOAP::ExchangeWebService::VERSION_2007_SP1

# see https://github.com/WinRb/Viewpoint/issues/184

start_date = Date.today.to_time.to_datetime
end_date = (start_date.to_time + 86399).to_datetime
p start_date
p end_date

events = cli.find_items({:folder_id => :calendar, :calendar_view => {:start_date => start_date, :end_date => end_date}})

message = "There are #{events.length} events today. "

events.each do |event|
  thistime = Time.strptime(event.start.iso8601,"%Y-%m-%dT%H:%M:%S%z")
  eventstarts = thistime.strftime("%R")
  message << "#{eventstarts} #{event.subject} "
end

Pushover.notification(message: message, title: 'EWS-CAL', sound: pushover_sound)

# see http://answer.io/p/ddacunha/Viewpoint

