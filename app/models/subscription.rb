class Subscription < ApplicationRecord
  validates :title, presence: true
  validates :price, presence: true
  validates :price, numericality: true
  validates :status, presence: true
  validates :frequency, presence: true
  validates :tea_units, presence: true
  validates :tea_units, numericality: true
  validates :tea_unit_size, presence: true
  validates :tea_unit_size, numericality: true

  belongs_to :tea, optional: true
  belongs_to :customer, optional: true
end
