module Pulsar
  module Validator
    def self.included(klass)
      klass.extend ClassMethods
      klass.before :validate_context!
    end

    def validate_context!
      validable_properties.each do |validable_property|
        validable_property.validate(context)
     end
    end

    def validable_properties
      self.class.validable_properties
    end
  end

  module ClassMethods
    def validate_context_for!(*args)
      args.each do |arg|
        validable_property = ValidableProperty.new(arg, block_given? ? Proc.new : nil)
        validable_properties << validable_property
      end
    end

    def validable_properties
      @validable_properties ||= []
    end


    # TODO: move this class into a separate file and test it 
    class ValidableProperty
      attr_reader :attribute, :block

      def initialize(attribute, block = nil)
        @attribute = attribute
        @block = block
      end

      def validate(context)
        result = if block
          block.call(context.send(attribute.to_sym), context)
        else
          context.send(attribute.to_sym)
        end

        context.fail! error: Pulsar::ContextError.new("Context failed with #{attribute} (it should not be #{result}") unless result
      end
    end
  end
end
