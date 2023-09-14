# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

  Subscription.destroy_all
  Customer.destroy_all
  Tea.destroy_all

  customer_1 = Customer.create!(first_name: "Ace", last_name: "Abe", email: "Ace@email.com", address: "1 Ace's pl, Denver, CO 80231")
  customer_2 = Customer.create!(first_name: "Billy", last_name: "Bob", email: "Billy@email.com", address: "1 Billy's pl, Denver, CO 80231")

  tea_1 = Tea.create!(title: "Earl Grey", description: "zesty", temperature: 185, brew_time_seconds: 180 )
  tea_2 = Tea.create!(title: "Black Tea", description: "robust", temperature: 190, brew_time_seconds: 240 )

  subscription_1 = Subscription.create!(title: "monthly saver", price: 9.99, status: "active", frequency: "monthly", tea_units: 30, tea_unit_size: 12, customer: customer_1, tea: tea_1 )
  subscription_2 = Subscription.create!(title: "half saver", price: 15.99, status: "active", frequency: "bi-weekly", tea_units: 15, tea_unit_size: 16, customer: customer_2, tea: tea_2 )
  subscription_3 = Subscription.create!(title: "montlhy saver", price: 5.99, status: "cancelled", frequency: "quarterly", tea_units: 90, tea_unit_size: 12, customer: customer_1, tea: tea_2 )
  subscription_4 = Subscription.create!(title: "flat deal saver", price: 4.99, status: "cancelled", frequency: "annual", tea_units: 730, tea_unit_size: 16, customer: customer_2, tea: tea_1 )
  subscription_5 = Subscription.create!(title: "flat deal saver", price: 4.99, status: "cancelled", frequency: "annual", tea_units: 730, tea_unit_size: 16, customer: customer_1 )
  subscription_6 = Subscription.create!(title: "flat deal saver", price: 4.99, status: "cancelled", frequency: "annual", tea_units: 730, tea_unit_size: 16, tea: tea_1 )
  subscription_7 = Subscription.create!(title: "flat deal saver", price: 4.99, status: "cancelled", frequency: "annual", tea_units: 730, tea_unit_size: 16 )
