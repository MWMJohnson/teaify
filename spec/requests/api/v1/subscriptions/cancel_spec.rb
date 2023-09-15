require 'rails_helper'

RSpec.describe 'Subscriptions' do
  describe "DELETE '/api/v1/customers/:customer_id/subscriptions/:id'" do 
    describe "happy paths" do
      it "cancels a customer's tea subscription" do 
        test_data
        expect(@subscription_2.customer).to eq @customer_2
        expect(@subscription_2.tea).to eq @tea_2
        expect(@subscription_2.status).to eq "active"
        
        headers = { 'CONTENT_TYPE' => 'application/json' }
        delete "/api/v1/customers/#{@customer_2.id}/subscriptions/#{@subscription_2.id}", headers: headers
        
        expect(response).to be_successful

        parsed = JSON.parse(response.body, symbolize_names: true)
        expect(parsed).to be_a Hash
        expect(parsed).to have_key :message
        expect(parsed[:message]).to eq "Subscription successfully cancelled"
      end
    end

    describe "sad path" do
      it "Subscription must exist to be cancelled" do 
        test_data
        expect(@subscription_2.customer).to eq @customer_2
        expect(@subscription_2.tea).to eq @tea_2
        expect(@subscription_2.status).to eq "active"
        
        headers = { 'CONTENT_TYPE' => 'application/json' }
        delete "/api/v1/customers/#{@customer_2.id}/subscriptions/000", headers: headers
        
        expect(response).to_not be_successful

        parsed = JSON.parse(response.body, symbolize_names: true)
        expect(parsed).to be_a Hash
        expect(parsed).to have_key :error
        expect(parsed[:error]).to eq "Subscription not found"
      end
    end
  end
end