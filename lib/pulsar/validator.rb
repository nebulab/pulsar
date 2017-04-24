module Pulsar
  module Validator
    def self.included(klass)
      klass.extend ClassMethods
      klass.before :validate_context!
    end

    def validate_context!
      validable_properties.each do |property|
        result = context.send property.to_sym
        context_fail! "Invalid context for #{property} [#{result}]" unless result
      end
    end

    def context_fail!(msg)
      context.fail! error: Pulsar::ContextError.new(msg)
    end

    def validable_properties
      self.class.validable_properties
    end

    module ClassMethods
      def validate_context_for!(*args)
        validable_properties.concat args
      end

      def validable_properties
        @validable_properties ||= []
      end
    end
  end
end
