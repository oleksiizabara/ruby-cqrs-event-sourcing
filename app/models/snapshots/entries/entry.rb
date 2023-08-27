module Snapshots
  module Entries
    class Entry < Dry::Struct
      module Types
        include Dry.Types()
      end

      def self.attribute(name, type = Undefined, setter: true, &block)
        super(name, type, &block)

        define_method("#{name}=") do |value|
          if setter
            reset new(name => value).attributes
          else
            raise NoMethodError, "undefined method `#{name}=' for #{self}"
          end
        end
      end

      def reset(attributes)
        @attributes = attributes
      end
    end
  end
end
