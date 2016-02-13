Dalli::Client.class_eval do
  def perform_with_profiling(*args)
    begin
      start_time = Time.now
      result = perform_without_profiling(*args)
    ensure
      time_ellasped = (Time.now - start_time) * 1_000
      command = args.first.is_a?(Array) ? args[0][0] : args.first
      Nightwing.client.timing "memcache.command.time", time_ellasped
      Nightwing.client.timing "memcache.command.#{command}.time", time_ellasped
    end

    result
  end
  alias perform_without_profiling perform
  alias perform perform_with_profiling
end if defined?(Dalli::Client)
