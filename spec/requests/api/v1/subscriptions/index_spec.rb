require 'rails_helper'

RSpec.describe 'Subscriptions' do
  describe 'GET api_v1_customer_subscriptions_path' do 
    describe "happy paths" do
      it "can get a list of a customer's tea subscriptions" do
        test_data

        get api_v1_customer_subscriptions_path(@customer_2)
        expect(response).to be_successful
        
        parsed = JSON.parse(response.body, symbolize_names: true)
        subscriptions = parsed[:data]

        expect(subscriptions).to be_an Array

        subscriptions.each do |subscription|
          expect(subscription).to be_a Hash

          expect(subscription).to have_key :id
          expect(subscription[:id]).to be_a String

          expect(subscription).to have_key :type
          expect(subscription[:type]).to eq "subscription"

          expect(subscription).to have_key :attributes
          expect(subscription[:attributes]).to be_a Hash

          attributes = subscription[:attributes]

          expect(attributes).to have_key :title
          expect(attributes[:title]).to be_a String

          expect(attributes).to have_key :price
          expect(attributes[:price]).to be_a Float

          expect(attributes).to have_key :status
          expect(attributes[:status]).to be_a String

          expect(attributes).to have_key :frequency
          expect(attributes[:frequency]).to be_a String

          expect(attributes).to have_key :tea_units
          expect(attributes[:tea_units]).to be_a Integer

          expect(attributes).to have_key :tea_unit_size
          expect(attributes[:tea_unit_size]).to be_a Integer

          expect(attributes).to have_key :customer_id
          expect(attributes[:customer_id]).to be_a Integer

          expect(attributes).to have_key :tea_id
          expect(attributes[:tea_id]).to be_a Integer
        end
      end

      it "returns all subscriptions regardless if status is active or cancelled" do 
        test_data

        get api_v1_customer_subscriptions_path(@customer_2)
        expect(response).to be_successful
        parsed = JSON.parse(response.body, symbolize_names: true)
        subscriptions = parsed[:data]

        expect(subscriptions[0][:attributes][:status]).to eq("active")
        expect(subscriptions[1][:attributes][:status]).to eq("cancelled")
      end
    end

    describe "sad path" do 
      it "returns an error message if the customer does not exist" do 
        get api_v1_customer_subscriptions_path(1909090909090990909009)
        
        expect(response).to_not be_successful
        parsed = JSON.parse(response.body, symbolize_names: true)
        
        expect(parsed[:error]).to eq "Customer not found"
      end
    end
  end
end