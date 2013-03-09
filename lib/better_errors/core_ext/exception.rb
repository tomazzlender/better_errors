module BetterErrors::CoreExt
  module Exception
    prepend_features ::Exception

    def initialize(*)
      return if Thread.current[:__better_errors_exception_lock]
      begin
        Thread.current[:__better_errors_exception_lock] = true
        if BetterErrors.binding_of_caller_available?
          @__better_errors_bindings_stack = binding.callers.drop(1)
        end
        super
      ensure
        Thread.current[:__better_errors_exception_lock] = false
      end
    end
  
    def __better_errors_bindings_stack
      @__better_errors_bindings_stack || []
    end
  end
end
