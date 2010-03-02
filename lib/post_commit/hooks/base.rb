module PostCommit
  module Hooks
    class Base
      # Hold the authorization options.
      attr_reader :credentials

      # Hold the latest response
      attr_reader :response

      # Hold the latest request object
      attr_reader :request

      # Hold the latest uri object
      attr_reader :uri

      # Hold options defined throught the PostCommit::Hooks::Base#set method
      attr_reader :options

      def initialize
        @credentials = {}
        @options = {}
      end

      def self.inherited(base)
        PostCommit::Hooks.register base.name.split("::").last.downcase.to_sym, base
      end

      # Set up the authorization for the current notifier.
      # Each notifier can have its own authorization options.
      def authorize(options = {})
        @credentials = options
      end

      # Set an option for the current hook.
      # The available options may vary from hook to hook and may not be available at all.
      #
      #   set :data_type, :json
      def set(name, value)
        @options[name.to_sym] = value
      end

      def post(options = {}) # :nodoc:
        raise PostCommit::AbstractMethodError
      end

      def convert_to_xml(hash) # :nodoc:
        xml_node = Proc.new do |name, value, buffer|
          buffer ||= ""

          if value.kind_of?(Hash)
            buffer << "<#{name}>"
            value.each {|n, v| buffer << xml_node[n, v] }
            buffer << "</#{name}>"
          else
            buffer << "<#{name}><![CDATA[#{value}]]></#{name}>"
          end

          buffer
        end

        root = hash.keys.first
        xml_node[root, hash[root]]
      end

      def convert_to_params(hash) # :nodoc:
        hash
      end
    end
  end
end
