class Tea < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :temperature, presence: true
  validates :brew_time_seconds, presence: true
  
  validates :temperature, numericality: true
  validates :brew_time_seconds, numericality: true

  has_many :subscriptions, dependent: :destroy
  has_many :customers, through: :subscriptions
end
