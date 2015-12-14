# ews-cal-pushover

##Tools for pushing events from Exhange Web Services to Pushover

In order to use this code, simply do the following:

Load required gems
   bundle install --path vendor/bundle

Generate config.yml and edit
   cp config.yml.example config.yml
   vim config.yml

Run commands below

## Commands

### list_events.rb

Test script to list events in the past day to the console

### push_events.rb

Pushes events in specified minutes ahead (default 30) to Pushover

### push_events_today.rb

Pushes summary of todays events to Pushover

## Contributions

Further contributions are encouraged.

## Author

Mark Tearle <mark@tearle.com>
