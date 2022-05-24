FactoryBot.define do
  factory :user do
    name {'test-user'}
    sequence :email do |n|
      "testuser#{n}@yopmail.com"
    end
    spends {0.0}
    loyalty_points {0}
  end
end
