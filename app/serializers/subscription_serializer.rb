class SubscriptionSerializer
  include JSONAPI::Serializer
  attributes  :title,
              :price,
              :status,
              :frequency,
              :tea_units,
              :tea_unit_size,
              :customer_id,
              :tea_id
end
