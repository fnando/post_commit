module PostCommit
  module Hooks
    class << self
      attr_accessor :hooks
    end

    # Register a hook.
    #
    #   PostCommit::Hooks.register :campfire, PostCommit::Hooks::Campfire
    def self.register(name, hook_class)
      self.hooks ||= {}
      self.hooks[name.to_sym] = hook_class
    end
  end
end
