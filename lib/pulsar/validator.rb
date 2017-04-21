module Pulsar
  module Validator
    def self.included(klass)
      klass.extend ClassMethods
      klass.before :validate_context!
    end

    def validate_context!
      validable_properties.each do |property, validator|
        result = if validator.is_a? Proc
                   validator.call(context.send(property), context)
                 else
                   context.send property.to_sym
                 end
        context_fail! "Invalid context for #{property} [#{result}]" unless result
      end
    end

    def context_fail!(msg)
      context.fail! error: Pulsar::ContextError.new(msg)
    end

    def validable_properties
      self.class.validable_properties
    end
  end

  module ClassMethods
    def validate_context_for!(*args)
      args.each do |arg|
        validable_properties[arg] = (block_given? ? Proc.new : nil)
      end
    end

    def validable_properties
      @validable_properties ||= {}
    end
  end
end
