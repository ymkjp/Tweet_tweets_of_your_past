class TweetSelector

    def initialize(csv)
        @target_file = csv
    end

    def get_row
        # XXX It occuers error if send a same tweet in recent 5 tweets
        rows = get_all
        row = select_row(rows)

        while is_reply_or_rt(row)
            row = select_row(rows)
        end

        return row
    end

    private

    def get_all
        all = []
        begin
            CSV.foreach(@target_file) do |row|
                all << row
            end
        rescue
            all << ["", "", "@ymkjp error[0]"]
        end

        return all
    end

    def select_row(rows)
        rows[rand(rows.size)]
    end

    def is_reply_or_rt(row)
        # 3rd column is the text of CSV's row
        is_reply_or_rt_regex = /^(@[0-9A-Za-z_]|RT)/
        #is_reply_regex = /^@[0-9A-Za-z_]/

        return is_reply_or_rt_regex =~ row[2]
    end
end
