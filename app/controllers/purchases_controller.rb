class PurchasesController < ApplicationController
  def create
    user = find_user
    CreatePaymentOperation.call(user, amount)
  end

  private

  def find_user
    User.find(params[:user_id])
  end

  def amount
    params[:amount]
  end
  
  # end of private
end
