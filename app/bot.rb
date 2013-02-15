#!/usr/bin/ruby
# encoding: utf-8

require "rubygems"
require "twitter"
require "logger"

require "cgi"
require "csv"
require 'date'
require 'uri'

require './application_keys'
require './tweet_selector'
require './tweet_former'
require './tweet_manager'

#csv = "../old_tweets/ymkjp000000.csv"
csv = "../old_tweets/ymkjp130107.csv"
LOG = Logger.new("../logs/bot.log")

MultiJson.engine = :ok_json
Twitter.configure do |config|
    config.consumer_key = CONSUMER_KEY
    config.consumer_secret = CONSUMER_SECRET
    config.oauth_token = ACCESS_TOKEN
    config.oauth_token_secret = ACCESS_TOKEN_SECRET
end

begin
    fetcher = TweetSelector.new(csv)
    tweet_row = fetcher.get_row
    tweet_row = TweetFormer.reform(tweet_row)
    TweetManager.send(tweet_row)
rescue => ex
    LOG.warn ex
end
