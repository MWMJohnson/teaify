FactoryBot.define do
  factory :subscription do
    title { "MyString" }
    price { 1.5 }
    status { "MyString" }
    frequency { "MyString" }
    tea_units { 1 }
    tea_unit_size { 1 }
    tea { nil }
    customer { nil }
  end
end
