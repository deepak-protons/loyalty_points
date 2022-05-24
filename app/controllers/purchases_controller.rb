class PurchasesController < ApplicationController
  def create
    user = find_user
    response = CreatePaymentOperation.call(user, amount, currency: currency)
    render json: response
  end

  private

  def find_user
    User.find(params[:user_id])
  end

  def amount
    params[:amount]
  end

  def currency
    params[:currency]
  end
  
  # end of private
end
