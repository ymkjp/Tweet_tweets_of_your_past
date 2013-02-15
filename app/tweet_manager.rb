class TweetManager
    def self.send(tweet_row)
        client = Twitter::Client.new
        tweet_txt = tweet_row[2]

        begin
            client.update(tweet_txt)
        rescue Twitter::Error::Forbidden => ex
            # this should be the message posted.
            LOG.warn ex.message
            exit
        rescue => ex
            client.update("@ymkjp error [2]")
            LOG.warn ex
            sleep 5
            retry
        end
    end
end
