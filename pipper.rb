#!/usr/bin/env ruby

require 'rubygems'
require 'time'
require 'date'
require 'yaml'
require 'twitter'
require 'active_support/time'

@config = YAML.load_file('config.yml')

@hour_word = {
  0 => "twelve",
  1 => "one",
  2 => "two", 
  3 => "three",
  4 => "four",
  5 => "five",
  6 => "six",
  7 => "seven",
  8 => "eight", 
  9 => "nine",
  10 => "ten",
  11 => "eleven",
  12 => "twelve",
  13 => "one", 
  14 => "two", 
  15 => "three",
  16 => "four",
  17 => "five",
  18 => "six",
  19 => "seven",
  20 => "eight",
  21 => "nine",
  22 => "ten",
  23 => "eleven",
  24 => "twelve"
}

Twitter.configure do |config|
  config.consumer_key = @config['twitter']['consumer_key']
  config.consumer_secret = @config['twitter']['consumer_secret']
  config.oauth_token = @config['twitter']['oauth_token']
  config.oauth_token_secret = @config['twitter']['oauth_token_secret']
end

@zone = ActiveSupport::TimeZone.new('NZ')
@now = @zone.now

# Basic sanity checking...
if (@now.min == 0)
  Twitter.update("beep beep beep beep beeeep. it's #{@hour_word[@now.hour]} o'clock.")
  #puts ("Beep beep beep beep beep beeeep. It's #{@hour_word[@now.hour]} o'clock.")
end
