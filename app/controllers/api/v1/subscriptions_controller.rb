class Api::V1::SubscriptionsController < ApplicationController
  before_action :find_customer

  def index
      subscriptions = @customer.subscriptions
      render json: SubscriptionSerializer.new(subscriptions), status: 200
  end
  
  def create
    find_tea
    if @tea.nil?
      render json: { error: 'Tea not found' }, status: :not_found
    else
      subscription = Subscription.find_by(customer_id: @customer.id, tea_id: @tea.id)
      if subscription 
        if subscription.status == "active"
          render json: { error: "Customer already has an active subscription for #{@tea.title}"}, status: :unprocessable_entity
        elsif subscription.status == "cancelled"
          subscription.update!(status: "active")
          render json: SubscriptionSerializer.new(subscription), status: 200
        end
      else
        created_subscription = Subscription.create!(subscription_params)
        created_subscription.update!(status: "active")
        render json: SubscriptionSerializer.new(created_subscription), status: :created
      end
    end
  end

  # def update
  #   find_subscription
  #   if @subscription.status == "cancelled"
  #     @subscription.update!(status: "active")
  #   end
  #   require 'pry'; binding.pry
  # end

  private
  def find_customer
    @customer = Customer.find_by(id: params[:customer_id])
    unless @customer
      render json: { error: 'Customer not found' }, status: :not_found
      return
    end
  end

  def find_tea
    # require 'pry'; binding.pry
    @tea = Tea.find_by(id: params[:tea_id])
    # unless @tea
    #   render json: { error: 'Tea not found' }, status: :not_found
    #   return
    # end
  end

  # def find_subscription
  #   @customer = Customer.find_by(id: params[:customer_id])
  #   @tea = Tea.find_by(id: params[:tea_id])
  #   @subscription = Subscription.find_by(id: params[:subscription_id])

  #   if @subscription
  #     @subscription
  #   else
  #     @subscription = Subscription.find_by(customer_id: @customer.id, tea_id: @tea.id)
  #     unless @subscription
  #       render json: { error: 'Subscription not found' }, status: :not_found
  #       return
  #     end
  #   end
  # end

  def subscription_params
    params.permit(:title, :price, :frequency, :tea_units, :tea_unit_size, :customer_id, :tea_id )
  end
end