module Pulsar
  module ExtendedInteractor
    module ClassMethod
      def validate_context_for(*keys)
        keys.each do |key|
          method_name = "validate_context_for_#{key}"
          if block_given?
            define_method method_name.to_sym do
              validate_context_for key, &Proc.new
            end
          else
            define_method method_name.to_sym do
              validate_context_for key
            end
          end
          before method_name.to_sym
        end
      end
    end

    include Interactor

    def self.included(klass)
      Interactor.included klass
      klass.extend ClassMethod
    end

    def validate_context_for(key)
      error_msg = "Invalid context: #{key} is not properly set"
      if block_given? && !yield(context.send(key), context)
        context.fail! error: Pulsar::ContextError.new(error_msg)
      elsif context.send(key).nil?
        context.fail! error: Pulsar::ContextError.new(error_msg)
      end
    end
  end
end
