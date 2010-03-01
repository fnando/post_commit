module PostCommit
  class Base
    class << self
      attr_accessor :controller
    end

    def self.activate(controller)
      self.controller = controller
    end
  end
end
