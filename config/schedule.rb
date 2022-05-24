every 1.month, at: '12:00 am' do
  User.all.each do |user|
    if user.dob.month == Date.current.month
      RewardAssignmentOperation.call(user: user, reward_name: 'free_coffee', quantity: 1)
    end
  end
end

every 1.year, at: '12:00 am' do
  User.all.each do |user|
    user.loyalty_points = 0
    user.save(validate: false)
  end
end

every 1.month, :at => ['January 1st 12:00am', 'May 1st 12:00am', 'September 1st 12:00am'] do
  User.all.each do |user|
    user_audits = user.audits.where('created_at': (Time.now.beginning_of_month-4.months)..Time.now.end_of_month).order(:created_at)
    quarterly_spendings = user_audits.last.user.spends - user_audits.first.user.spends
    if quarterly_spendings > 2000
      user.loyalty_points += 100
      user.save(validate: false)
    end
  end
end
