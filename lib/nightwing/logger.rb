module Nightwing
  class Logger
    def debug(msg)
      print :debug, msg
    end

    def info(msg)
      print :info, msg
    end

    def warn(msg)
      print :warn, msg
    end

    private

    def print(level, msg)
      puts "#{Time.now} nightwing.#{level}: #{msg}"
    end
  end
end
