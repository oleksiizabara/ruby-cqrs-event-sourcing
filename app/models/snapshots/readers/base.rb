module Snapshots
  module Readers
    class Base
      def initialize(key)
        @key = "#{key_prefix}:#{key}"
      end

      private

      attr_reader :key
      delegate_missing_to :storage

      def key_prefix
        @key_prefix ||= self.class.name.demodulize.underscore
      end

      def storage
        $redis
      end
    end
  end
end
