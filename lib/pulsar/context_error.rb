module Pulsar
  class ContextError < StandardError
    def to_s
      backtrace ? backtrace.unshift(super).join("\n") : super
    end
  end
end
