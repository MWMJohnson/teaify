require 'rails_helper'

RSpec.describe 'Subscriptions' do
  describe "POST api_v1_customer_subscriptions_path" do 
    describe "happy paths" do
      it "allows a customer to add a tea subscription" do 
        test_data
        expect(@customer_2.teas.to_a).to eq([@tea_1, @tea_2])
        @tea_3 = Tea.create!(title: "Green Tea", description: "soothing", temperature: 185, brew_time_seconds: 300 )

        subscription_valid_params = {
          title: "test title",
          price: 4.99,
          frequency: "monthly",
          tea_units: 30,
          tea_unit_size: 20,
          tea_id: @tea_3.id
        }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        post api_v1_customer_subscriptions_path(@customer_2), headers: headers, params: JSON.generate(subscription_valid_params)
        
        expect(response).to be_successful

        parsed = JSON.parse(response.body, symbolize_names: true)
        subscription = parsed[:data]

        created_subscription = Subscription.last
        
        expect(subscription).to be_a Hash

        expect(subscription).to have_key :id
        expect(subscription[:id]).to be_a String
        expect(subscription[:id]).to eq created_subscription.id.to_s

        expect(subscription).to have_key :type
        expect(subscription[:type]).to be_a String
        expect(subscription[:type]).to eq "subscription"

        expect(subscription).to have_key :attributes
        expect(subscription[:attributes]).to be_a Hash

        attributes = subscription[:attributes]
        
        expect(attributes)
        expect(attributes).to have_key :title
        expect(attributes[:title]).to be_a String
        expect(attributes[:title]).to eq created_subscription.title

        expect(attributes).to have_key :price
        expect(attributes[:price]).to be_a Float
        expect(attributes[:price]).to eq created_subscription.price

        expect(attributes).to have_key :status
        expect(attributes[:status]).to be_a String
        expect(attributes[:status]).to eq created_subscription.status
        expect(attributes[:status]).to eq "active"

        expect(attributes).to have_key :frequency
        expect(attributes[:frequency]).to be_a String
        expect(attributes[:frequency]).to eq created_subscription.frequency

        expect(attributes).to have_key :tea_units
        expect(attributes[:tea_units]).to be_a Integer
        expect(attributes[:tea_units]).to eq created_subscription.tea_units

        expect(attributes).to have_key :tea_unit_size
        expect(attributes[:tea_unit_size]).to be_a Integer
        expect(attributes[:tea_unit_size]).to eq created_subscription.tea_unit_size

        expect(attributes).to have_key :customer_id
        expect(attributes[:customer_id]).to be_a Integer
        expect(attributes[:customer_id]).to eq created_subscription.customer_id

        expect(attributes).to have_key :tea_id
        expect(attributes[:tea_id]).to be_a Integer
        expect(attributes[:tea_id]).to eq created_subscription.tea_id
      end

      it "allows a customer to re-subscribe to a cancelled tea subscription" do 
        test_data
        expect(@customer_2.teas.to_a).to eq([@tea_1, @tea_2])
        @tea_3 = Tea.create!(title: "Green Tea", description: "soothing", temperature: 185, brew_time_seconds: 300 )

        subscription_valid_params = {
          title: "test title",
          price: 4.99,
          frequency: "monthly",
          tea_units: 30,
          tea_unit_size: 20,
          tea_id: @tea_3.id
        }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        post api_v1_customer_subscriptions_path(@customer_2), headers: headers, params: JSON.generate(subscription_valid_params)
        
        created_subscription = Subscription.last
        created_subscription.update!(status: "cancelled")

        post api_v1_customer_subscriptions_path(@customer_2), headers: headers, params: JSON.generate(subscription_valid_params)

        expect(response).to be_successful

        created_subscription = Subscription.last

        parsed = JSON.parse(response.body, symbolize_names: true)
        subscription = parsed[:data]

        attributes = subscription[:attributes]

        expect(attributes).to have_key :status
        expect(attributes[:status]).to be_a String
        expect(attributes[:status]).to eq created_subscription.status
        expect(attributes[:status]).to eq "active"
      end
    end


    describe "sad paths" do
      it "Customer can only have one active subscription per tea" do 
        test_data
        expect(@customer_2.teas.to_a).to eq([@tea_1, @tea_2])
        @tea_3 = Tea.create!(title: "Green Tea", description: "soothing", temperature: 185, brew_time_seconds: 300 )

        subscription_valid_params = {
          title: "test title",
          price: 4.99,
          frequency: "monthly",
          tea_units: 30,
          tea_unit_size: 20,
          tea_id: @tea_3.id
        }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        post api_v1_customer_subscriptions_path(@customer_2), headers: headers, params: JSON.generate(subscription_valid_params)
        post api_v1_customer_subscriptions_path(@customer_2), headers: headers, params: JSON.generate(subscription_valid_params)
        
        expect(response).to_not be_successful

        parsed = JSON.parse(response.body, symbolize_names: true)
        expect(parsed).to be_a Hash
        expect(parsed).to have_key :error
        expect(parsed[:error]).to eq "Customer already has an active subscription for #{@tea_3.title}"
      end

      it "Must be a valid Customer" do 
        @tea_3 = Tea.create!(title: "Green Tea", description: "soothing", temperature: 185, brew_time_seconds: 300 )

        subscription_valid_params = {
          title: "test title",
          price: 4.99,
          frequency: "monthly",
          tea_units: 30,
          tea_unit_size: 20,
          tea_id: @tea_3.id
        }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        post api_v1_customer_subscriptions_path(0), headers: headers, params: JSON.generate(subscription_valid_params)
        
        expect(response).to_not be_successful

        parsed = JSON.parse(response.body, symbolize_names: true)
        expect(parsed).to be_a Hash
        expect(parsed).to have_key :error
        expect(parsed[:error]).to eq "Customer not found"
      end

      it "Must be a valid Tea" do 
        test_data
        expect(@customer_2.teas.to_a).to eq([@tea_1, @tea_2])

        subscription_valid_params = {
          title: "test title",
          price: 4.99,
          frequency: "monthly",
          tea_units: 30,
          tea_unit_size: 20,
          tea_id: 0000
        }

        headers = { 'CONTENT_TYPE' => 'application/json' }
        post api_v1_customer_subscriptions_path(@customer_2), headers: headers, params: JSON.generate(subscription_valid_params)
        
        expect(response).to_not be_successful

        parsed = JSON.parse(response.body, symbolize_names: true)
        expect(parsed).to be_a Hash
        expect(parsed).to have_key :error
        expect(parsed[:error]).to eq "Tea not found"
      end
    end
  end
end