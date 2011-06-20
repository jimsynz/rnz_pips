#!/usr/bin/env ruby

require 'rubygems'
require 'time'
require 'date'
require 'yaml'
require 'twitter'
require 'active_support/time'

@config = YAML.load_file('config.yml')

if @config['leap_seconds']
  #leap seconds are enabled.
  unless (File.exists?(@config['leap_seconds']['local_file']) && (File.mtime(@config['leap_seconds']['local_file']).to_i > (Time.now.to_i - @config['leap_seconds']['cache_ttl'])))
    # Need to download the NIST leap seconds file.
    require 'net/ftp'
    require 'uri'
    uri = URI.parse(@config['leap_seconds']['list_source'])
    Net::FTP.open(uri.host) do |ftp|
      ftp.login
      ftp.getbinaryfile(uri.path, @config['leap_seconds']['local_file'])
    end
  end
  highest = 0
  File.open(@config['leap_seconds']['local_file'],'r') do |list|
    list.each_line do |line|
      next if line =~ /^#/
      i = line.to_i
      highest = i if i > highest
    end
  end
  utc = ActiveSupport::TimeZone.new('UTC')
  leap = utc.at highest - @config['leap_seconds']['ntp_offset']
  now = utc.now
  # Dont test down to the second because CRON might be slightly wonky.
  if ((leap.year == now.year) && (leap.yday == now.yday) && (leap.hour == now.hour) && (leap.min == now.min))
    @leap_second = true
  end
end

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
  if @leap_second
    Twitter.update ("Beep beep beep beep beep beep beeeep. It's #{@hour_word[@now.hour]} o'clock.")
  else
    Twitter.update ("Beep beep beep beep beep beeeep. It's #{@hour_word[@now.hour]} o'clock.")
  end
end
