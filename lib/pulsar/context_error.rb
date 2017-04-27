module Pulsar
  class ContextError < StandardError
    attr_reader :exit_code
    def initialize(obj, exit_code)
      super obj
      @exit_code = exit_code
    end

    def to_s
      backtrace ? backtrace.unshift(super).join("\n") : super
    end
  end
end
