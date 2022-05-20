module CreatePurchaseOperation
  class << self
    def call(user, amount, error_tracker: OperationUtils::ErrorTracker.new)
      begin
        result = process(user, amount)
      rescue OperationUtils::Exceptions::CreatePurchaseOperationError => e
        error_tracker.add_errors(e.errors)
      end

      OperationResponseBuilder.call(result, error_tracker)
    end

    private

    def process(user, amount)
      payment = user.payments.new(amount: amount, currency: 'USD')
      if payment.save
      else
        raise_error(payment.errors.full_messages)
      end
    end

    def raise_error(errors)
      raise OperationUtils::Exceptions::CreatePurchaseOperationError.new(errors)
    end
  end
end