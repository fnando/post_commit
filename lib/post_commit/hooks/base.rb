module PostCommit
  module Hooks
    class Base
      # Hold the authorization options.
      attr_accessor :credentials

      # Hold the latest response
      attr_reader :response

      # Hold the latest request object
      attr_reader :request

      # Hold the latest uri object
      attr_reader :uri

      def initialize
        @credentials = {}
      end

      # Set up the authorization for the current notifier.
      # Each notifier can have its own authorization options.
      def authorize(options = {})
        @credentials = options
      end

      def post(options = {}) # :nodoc:
        raise PostCommit::AbstractMethodError
      end
    end
  end
end
