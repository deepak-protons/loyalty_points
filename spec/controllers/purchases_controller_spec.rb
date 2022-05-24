require 'rails_helper'

RSpec.describe PurchasesController, type: :controller do
  before :each do
    request.env["HTTP_ACCEPT"] = 'application/json'
  end

  describe "POST #create" do 
    context "when puchase in usd" do
      let!(:user) { create(:user, name: 'user1', email: 'user1@yopmail.com')} 

      it "should be 8 loyalty points" do

        post :create, params: {user_id: user.id, amount: 40, currency: 'usd'}
        response_body = JSON.parse(response.body)

        expect(response.status).to eq(200)
        expect(response_body['status']).to eq('success')
        expect(response_body['result']['amount']).to eq(40)
        expect(user.reload.loyalty_points).to eq(8)
      end

      it "should be 100 loyalty points" do

        post :create, params: {user_id: user.id, amount: 150, currency: 'usd'}
        response_body = JSON.parse(response.body)

        expect(response.status).to eq(200)
        expect(response_body['status']).to eq('success')
        expect(response_body['result']['amount']).to eq(150)
        expect(user.reload.loyalty_points).to eq(20)
      end
    end
    context "when puchase in foreign currency" do
      let!(:user) { create(:user, name: 'user1', email: 'user1@yopmail.com')} 

      it "should be 16 loyalty points" do

        post :create, params: {user_id: user.id, amount: 40, currency: 'inr'}
        response_body = JSON.parse(response.body)

        expect(response.status).to eq(200)
        expect(response_body['status']).to eq('success')
        expect(response_body['result']['amount']).to eq(40)
        expect(user.reload.loyalty_points).to eq(16)
      end

      it "should be 40 loyalty points" do

        post :create, params: {user_id: user.id, amount: 150, currency: 'inr'}
        response_body = JSON.parse(response.body)

        expect(response.status).to eq(200)
        expect(response_body['status']).to eq('success')
        expect(response_body['result']['amount']).to eq(150)
        expect(user.reload.loyalty_points).to eq(40)
      end
    end
  end
end
