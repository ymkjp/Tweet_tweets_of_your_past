#!/usr/bin/ruby

require "rubygems"
require "twitter"
require "logger"
require "optparse"

require './application_keys'

OPTS = {}
opt = OptionParser.new
opt.on('-d', '--daemon') {|v| OPTS[:d] = v }

argv = opt.parse(ARGV)

LOG = Logger.new("./logs/bot.log")

MultiJson.engine = :ok_json
Twitter.configure do |config|
    config.consumer_key = CONSUMER_KEY
    config.consumer_secret = CONSUMER_SECRET
    config.oauth_token = ACCESS_TOKEN
    config.oauth_token_secret = ACCESS_TOKEN_SECRET
end

if OPTS[:d]
    exit if fork
    Process.setsid
end
client = Twitter::Client.new
begin
    client.update("テストツイート")
rescue Twitter::Error::Forbidden => ex
    # this should be the message posted.
    LOG.warn ex.message
    exit
rescue => ex
    LOG.warn ex
    sleep 5
    retry
end

