class SubscriptionsController < ApplicationController
  def index
    customer = Customer.find_by(id: params[:customer_id])
    if customer
      subscriptions = customer.subscriptions
      render json: SubscriptionSerializer.new(subscriptions), status: 200
    else
      render json: { error: "The Customer ID you entered is not valid."}
    end
  end
end