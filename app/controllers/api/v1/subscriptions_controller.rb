class Api::V1::SubscriptionsController < ApplicationController
  before_action :find_customer, only: [:index, :create, :cancel]
  before_action :find_tea, only: [:create]
  before_action :find_subscription, only: [:create, :cancel]

  ACTIVE_STATUS = 'active'.freeze
  CANCELLED_STATUS = 'cancelled'.freeze

  def index
    subscriptions = @customer.subscriptions
    render json: SubscriptionSerializer.new(subscriptions), status: 200
  end

  def create
    return handle_existing_subscription(@subscription) if @subscription
    created_subscription = Subscription.create!(subscription_params.merge(status: ACTIVE_STATUS))
    render_subscription(created_subscription, :created)
  end

  def cancel
    if @subscription
      @subscription.update(status: CANCELLED_STATUS)
      render json: { message: 'Subscription successfully cancelled' }, status: :ok
    else
      render json: { error: 'Subscription not found' }, status: :not_found
    end
  end

  private

  def find_customer
    @customer = Customer.find_by(id: params[:customer_id])
    render_customer_not_found unless @customer
  end

  def find_tea
    @tea = Tea.find_by(id: params[:tea_id])
    render_tea_not_found unless @tea
  end

  def find_subscription
    @subscription = Subscription.find_by(customer_id: params[:customer_id], tea_id: params[:tea_id])
    if @subscription
      @subscription
    else
      @subscription = Subscription.find_by(id: params[:id], customer_id: params[:customer_id])
    end
  end

  def handle_existing_subscription(subscription)
    if subscription.status == ACTIVE_STATUS
      render json: { error: "Customer already has an active subscription for #{subscription.tea.title}" }, status: :unprocessable_entity
    elsif subscription.status == CANCELLED_STATUS
      subscription.update!(status: ACTIVE_STATUS)
      render_subscription(subscription, :ok)
    end
  end

  def render_subscription(subscription, status)
    render json: SubscriptionSerializer.new(subscription), status: status
  end

  def render_customer_not_found
    render json: { error: 'Customer not found' }, status: :not_found
  end

  def render_tea_not_found
    render json: { error: 'Tea not found' }, status: :not_found
  end

  def subscription_params
    params.permit(:title, :price, :frequency, :tea_units, :status, :tea_unit_size, :customer_id, :tea_id)
  end
end
