class Payment < ApplicationRecord
  
  audited

  # Association
  belongs_to :user

  # Scopes
  scope :amount_more_than_100, -> { where('amount > ?', 100 ) }
  scope :first_60_days, -> { where('DATE(created_at) <= ?', first_payment_in_utc_on + 60.days)  }

  private

  def self.first_payment_at
    Payment.order(created_at: :asc).first.created_at
  end

  def self.first_payment_in_utc_on
    first_payment_at.utc.to_date
  end

  # end of private
end
