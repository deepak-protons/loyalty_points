module OperationUtils
  module Exceptions
    module Vib
      class BaseError < StandardError
        attr_reader :errors

        def initialize(errors)
          @errors = [*errors]
        end

        def message
          @errors.join(", ")
        end
      end
    end
  end
end
