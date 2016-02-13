module Nightwing
  module Instrumentation
    # This code was influenced by Matt Aimonetti's awesome blog post: "Practical Guide to StatsD/Graphite Monitoring"
    # Check it out: https://matt.aimonetti.net/posts/2013/06/26/practical-guide-to-graphite-monitoring
    class ActiveRecord
      SQL_INSERT_DELETE_PARSER_REGEXP = /^(\w+)\s(\w+)\s\W*(\w+)/
      SQL_SELECT_REGEXP = /select .*? FROM \W*(\w+)/i
      SQL_UPDATE_REGEXP = /update \W*(\w+)/i

      def call(_name, started, finished, _unique_id, payload)
        if payload[:name] == "SQL" || payload[:name] =~ /.* Load$/ || payload[:name].nil?
          table, action = query_info(payload[:sql])
        end

        if table
          query_time = (finished - started) * 1_000
          Nightwing.client.timing("sql.#{table.downcase}.#{action.downcase}.time", query_time.round)
        end
      end

      private

      def query_info(query)
        case query
        when SQL_INSERT_DELETE_PARSER_REGEXP
          [$3, $1]
        when SQL_UPDATE_REGEXP
          [$1, "update"]
        when SQL_SELECT_REGEXP
          [$1, "select"]
        end
      end
    end
  end
end
