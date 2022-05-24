module UpdateRoleOperation
  class << self
    def call(user, error_tracker: OperationUtils::ErrorTracker.new)
      begin
        result = process(user)
      rescue OperationUtils::Exceptions::UpdateRoleOperationError => e
        error_tracker.add_errors(e.errors)
      end

      OperationResponseBuilder.call(result, error_tracker)
    end

    private

    def process(user)
      if user.loyalty_points.zero?
        user.standard!
      elsif user.loyalty_points >= 1000
        user.gold!
        RewardAssignmentOperation.call(user: user, reward_name: 'airport_lounge_access', quantity: 4)
      elsif user.loyalty_points >= 5000
        user.platinum!
      end
      
      user
    rescue Exception => e
      raise_error(e.message)
    end

    def raise_error(errors)
      raise OperationUtils::Exceptions::UpdateRoleOperationError.new(errors)
    end
  end
end