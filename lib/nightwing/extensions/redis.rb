Redis::Client.class_eval do
  def call_with_profiling(*args, &blk)
    begin
      start_time = Time.now
      result = call_without_profiling(*args, &blk)
    ensure
      time_ellasped = (Time.now - start_time) * 1_000
      command = args.first.is_a?(Array) ? args[0][0] : args.first

      Nightwing.client.timing "redis.command.time", time_ellasped
      Nightwing.client.timing "redis.command.#{command}.time", time_ellasped

      Nightwing.client.increment "redis.command.processed"
      Nightwing.client.increment "redis.command.#{command}.processed"
    end

    result
  end
  alias call_without_profiling call
  alias call call_with_profiling
end if defined?(Redis::Client)
