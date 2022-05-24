class User < ApplicationRecord
  
  audited
  
  # Association
  has_many :payments
  has_many :user_rewards
  has_many :rewards, through: :user_rewards

  # Enums
  enum role: {'standard': 0, 'gold': 1, 'platinum': 2}

end
