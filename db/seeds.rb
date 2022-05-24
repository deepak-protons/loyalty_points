
['free_coffee', '5_percent_cash_rebate', 'free_movie_tickets', 'airport_lounge_access'].each do |reward_name|
  reward = Reward.new(name: reward_name)
  reward.save(validate: false)
end