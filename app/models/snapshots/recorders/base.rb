module Snapshots
  module Recorders
    class Base
      def initialize(key)
        @key = build_key(key)
      end

      private

      attr_reader :key
      delegate_missing_to :storage

      def build_key(key)
        "#{key_prefix}:#{key}"
      end

      def key_prefix
        @key_prefix ||= self.class.name.demodulize.underscore
      end

      def unbuilt_key
        @unbuilt_key ||= key.split(":").last
      end

      def storage
        $redis
      end
    end
  end
end
