module Pulsar
  module ErrorHandler
    def context_fail!(params = {})
      context.errors ||= []
      errors = params.delete :errors
      context.errors << errors if errors
      context.fail! params
    end
  end
end

Interactor.class_eval do
  include Pulsar::ErrorHandler
end
