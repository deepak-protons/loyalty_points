module CreatePaymentOperation
  class << self
    def call(user, amount, currency: 'usd', error_tracker: OperationUtils::ErrorTracker.new)
      begin
        result = process(user, amount, currency, error_tracker)
      rescue OperationUtils::Exceptions::CreatePaymentOperationError => e
        error_tracker.add_errors(e.errors)
      end

      OperationResponseBuilder.call(result, error_tracker)
    end

    private

    def process(user, amount, currency, error_tracker)
      payment = user.payments.new(amount: amount, currency: currency)
      if payment.save
        reward_assignment_operation(user: user, reward_name: 'five_percent_cash_rebate', quantity: 1) if is_10_or_mote_payments_amount_more_than_100
        reward_assignment_operation(user: user, reward_name: 'free_movie_ticket', quantity: 1) if is_spendings_greater_than_1000_within_60_days_of_first_transaction
      else
        raise_error(payment.errors.full_messages)
      end

      UpdatePointsOperation.call(user, payment, error_tracker: error_tracker)

      payment
    end

    def is_spendings_greater_than_1000_within_60_days_of_first_transaction
      return true if Payment.first_60_days.sum(:amount) > 1000

      false
    end

    def is_10_or_mote_payments_amount_more_than_100
      return true if Payment.amount_more_than_100.count >= 10
      
      false
    end

    def raise_error(errors)
      raise OperationUtils::Exceptions::CreatePaymentOperationError.new(errors)
    end
  end
end