# encoding: utf-8
class TweetFormer
    class << self
    def reform(tweet_row)
        tweet_txt = remove_hashtag(remove_reply(unescape_html(tweet_row[2])))
        tweet_txt = diminish_characters(tweet_txt) if tweet_txt.size >= 128
        tweet_row[2] = append_date(tweet_txt, tweet_row[1])

        return tweet_row
    end

    private

        def remove_hashtag(str)
            str.gsub(/#/, '')
        end

        def remove_reply(str)
            str.gsub(/@/, '')
        end

        def unescape_html(str)
            CGI.unescapeHTML(str)
        end

        def diminish_characters(str)
            str = str.gsub(URI.regexp, '').slice(0..127)
            str += "…"
        end

        def append_date(tweet_txt, date_column)
            date = date_column.slice(0..5)
            date = Date.strptime(date, "%y%m%d").to_s
            tweet_txt += "\n#{date}"

            return tweet_txt
        end
    end
end
