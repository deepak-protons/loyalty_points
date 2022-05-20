# OperationResponseBuilder.call(result, error_tracker)
# this will accept result and error_tracker and return operation response

module OperationResponseBuilder
  class << self
    def call(result, error_tracker)
      {
        status: error_tracker.status,
        errors: error_tracker.list_errors,
        result: result
      }
    end
  end
end
