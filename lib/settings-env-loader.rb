require "enumerator"

module Settings
  module Env
    module Loader
      VERSION = "0.0.1"

      # Merges ENV and modify the hash directly
      def merge_env(prefix = nil, separator = '_')
        Merger.new(prefix, separator, self).merge
        self
      end

      # Iterates the Hash as ENV key value pairs
      def each_env(prefix = nil, separator = '_')
        Enumerator.new do |y|
          Exporter.new(prefix, separator, self).each(y)
        end
      end

      class Merger
        def initialize(prefix, separator, hash)
          @prefix = prefix
          @separator = separator
          @hash = hash
        end

        def merge
          @hash.each do |key, value|
            env_name = [@prefix, key].compact.join(@separator).upcase

            if value.is_a?(Hash)
              Merger.new(env_name, @separator, value).merge
            else
              env_value = ENV[env_name]
              if env_value
                @hash[key] = convert(env_value, value)
              end
            end
          end
        end

        def convert(value, origin_value)
          case origin_value
          when Symbol
            value.to_sym
          when Fixnum
            value.to_i
          when Float
            value.to_f
          when Array
            Array(YAML.load(value))
          else
            value
          end
        end
      end

      class Exporter
        def initialize(prefix, separator, hash)
          @prefix = prefix
          @separator = separator
          @hash = hash
        end

        def each(y)
          @hash.each do |key, value|
            env_name = [@prefix, key].compact.join(@separator).upcase
            if value.is_a?(Hash)
              Exporter.new(env_name, @separator, value).each(y)
            else
              y << [env_name, value.to_s]
            end
          end
        end
      end
    end
  end
end
