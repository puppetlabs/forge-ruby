module PuppetForge
  module Middleware

    # SymbolifyJson is a Faraday Middleware that will process any response formatted as a hash
    # and change all the keys into symbols (as long as they respond to the method #to_sym.
    #
    # This middleware makes no changes to the values of the hash.
    # If the response is not a hash, no changes will be made.
    class SymbolifyJson < Faraday::Middleware

      # Processes an array
      #
      # @return an array with any hash's keys turned into symbols if possible
      def process_array(array)
        array.map do |arg|
          # Search any arrays and hashes for hash keys
          if arg.is_a? Hash
            process_hash(arg)
          elsif arg.is_a? Array
            process_array(arg)
          else
            arg
          end
        end
      end

      # Processes a hash
      #
      # @return a hash with all keys turned into symbols if possible
      def process_hash(hash)
        
        # hash.map returns an array in the format
        # [ [key, value], [key2, value2], ... ]
        # Hash[] converts that into a hash in the format
        # { key => value, key2 => value2, ... }
        Hash[hash.map do |key, val|
          # Convert to a symbol if possible
          if key.respond_to? :to_sym
            new_key = key.to_sym
          else
            new_key = key
          end

          # If value is a hash or array look for more hash keys inside.
          if val.is_a?(Hash)
            [new_key, process_hash(val)]
          elsif val.is_a?(Array)
            [new_key, process_array(val)]
          else
            [new_key, val]
          end
        end]
      end

      def process_response(env)
        if !env["body"].nil? && env["body"].is_a?(Hash)
          process_hash(env.body)
        else
          env.body
        end
      end

      def call(environment)
        @app.call(environment).on_complete do |env|
          env.body = process_response(env)
        end
      end

    end
  end
end

