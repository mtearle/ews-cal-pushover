require 'rubygems'
require 'bundler/setup'
require 'nokogiri'
require 'yaml'

require 'viewpoint'
include Viewpoint::EWS

config = YAML.load_file("config.yml")

endpoint = config["ews"]["endpoint"]
user = config["ews"]["user"]
pass = config["ews"]["pass"]

cli = Viewpoint::EWSClient.new endpoint, user, pass, server_version: SOAP::ExchangeWebService::VERSION_2007_SP1

calendar = cli.get_folder(:calendar)

calendar.items.each do |item|

#calendar.todays_items.each do |item|
  p item.subject
#  p item.required_attendees
end

# see http://answer.io/p/ddacunha/Viewpoint
