module RewardAssignmentOperation
  class << self
    def call(user, reward_name, quantity, error_tracker: OperationUtils::ErrorTracker.new)
      begin
        result = process(user, reward_name, quantity)
      rescue OperationUtils::Exceptions::RewardAssignmentOperationError => e
        error_tracker.add_errors(e.errors)
      end

      OperationResponseBuilder.call(result, error_tracker)
    end

    private

    def process(user, reward_name, quantity)
      reward = get_reward(reward_name)
      user_reward = UserReward.find_or_initialize_by(user_id: user.id, reward_id: reward.id)
      user_reward.quantity += quantity      

      raise_error(user_reward.errors.full_messages) if !user_reward.save

      user_reward
    end

    def get_reward(reward_name)
      Reward.find_or_initialize_by(reward_name: reward_name)

      raise_error(reward.errors.full_messages) if !reward.save

      reward
    end

    def raise_error(errors)
      raise OperationUtils::Exceptions::RewardAssignmentOperationError.new(errors)
    end
  end
end
