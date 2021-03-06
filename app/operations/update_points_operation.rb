module UpdatePointsOperation
  class << self
    def call(user, payment, error_tracker: OperationUtils::ErrorTracker.new)
      begin
        result = process(user, payment, error_tracker)
      rescue OperationUtils::Exceptions::UpdatePointsOperationError => e
        error_tracker.add_errors(e.errors)
      end

      OperationResponseBuilder.call(result, error_tracker)
    end

    private

    def process(user, payment, error_tracker)
      user = update_spendings_and_layalty_points(user, payment)
      if is_user_accumulates_100_points_in_one_calendar_month(user, payment)
        RewardAssignmentOperation.call(user: user, reward_name: 'free_coffee', quantity: 1)
      end

      UpdateRoleOperation.call(user, error_tracker: error_tracker)

      user
    end

    def update_spendings_and_layalty_points(user, payment)
      points_earned_from_current_payment = get_current_payment_earned_points(payment)
      remaining_current_payment_amount = payment.amount % 100
      remaining_spends = user.spends % 100
      points_from_remaining_amount = if payment.currency == 'usd' 
        ((remaining_spends + remaining_current_payment_amount) / 100) * 10
      else
        ((remaining_spends + remaining_current_payment_amount) / 100) * 20
      end
      points_earned_from_current_payment += points_from_remaining_amount
      new_updated_spends = user.spends + payment.amount
      new_earned_points = user.loyalty_points + points_earned_from_current_payment

      if !user.update(spends: new_updated_spends, loyalty_points: new_earned_points)
        raise_error(user.errors.full_messages)
      end

      user
    end

    def get_current_payment_earned_points(payment)
      if payment.currency == 'usd'
        (payment.amount / 100) * 10
      else
        (payment.amount / 100) * 20
      end
    end

    def is_user_accumulates_100_points_in_one_calendar_month(user, payment)
      user_audits = user.audits.where('created_at': Time.now.beginning_of_month..Time.now.end_of_month).order(created_at: :asc)
      
      return false if user_audits.none?

      current_month_earned_loyalty_points = get_audited_user(user_audits.last).loyalty_points - get_audited_user(user_audits.first).loyalty_points

      return true if current_month_earned_loyalty_points >= 100
      
      false
    end

    def get_audited_user(audit_obj)
      User.find(audit_obj.auditable_id)
    end

    def raise_error(errors)
      raise OperationUtils::Exceptions::UpdatePointsOperationError.new(errors)
    end
  end
end
