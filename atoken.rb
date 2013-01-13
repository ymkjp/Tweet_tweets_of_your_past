#!/usr/bin/ruby
# encoding: utf-8

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

###
require "csv"
#target = "./old_tweets/ymkjp000000.csv"
target = "./old_tweets/ymkjp130107.csv"

def choose_tweet(target)
    # XXX error handling
    all_tweets = []
    CSV.foreach(target) do |row|
        all_tweets << row
    end

    return all_tweets[rand(all_tweets.length)]
end

def detoxify_tweet(str)
    # remove Hashtag(#) and Reply(@)
    str.gsub!(/@/, '')
    str.gsub!(/#/, '')

    return str.slice!(139...-1)
end

chosen_tweet = choose_tweet(target)

# choose again if the chosen tweet is the reply to someone
is_reply = /^@[0-9A-Za-z_]/
is_reply_or_RT = /^(@[0-9A-Za-z_]|RT)/
while is_reply =~ chosen_tweet[2]
    chosen_tweet = choose_tweet(target)
end

tweet_str = detoxify_tweet(chosen_tweet[2])
tweet_str ||= "@ymkjp error[01]"
###

if OPTS[:d]
    exit if fork
    Process.setsid
end
client = Twitter::Client.new

begin
    client.update(tweet_str)
    #client.update("テストツイート")
rescue Twitter::Error::Forbidden => ex
    # this should be the message posted.
    LOG.warn ex.message
    exit
rescue => ex
    LOG.warn ex
    sleep 5
    retry
end

