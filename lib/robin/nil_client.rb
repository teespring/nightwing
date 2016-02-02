module Robin
  class NilClient
    def increment(*args)
    end

    def measure(*args)
    end
    alias timing measure
  end
end
