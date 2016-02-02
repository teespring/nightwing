require "rspec"
require "robin"

class FakeClient
  def increment(*args)
  end

  def measure(*args)
  end
  alias timing measure
end
