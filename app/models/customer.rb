class Customer < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :address, presence: true
  validates :email, presence: true
  validates :email, uniqueness: true

  has_many :subscriptions, dependent: :destroy
  has_many :teas, through: :subscriptions

  # def customer_active_subscriptions
  #   self.subscriptions.where('status = active')
  # end

  # def customer_cancelled_subscriptions
  #   self.subscriptions.where('status = cancelled')
  # end

end
