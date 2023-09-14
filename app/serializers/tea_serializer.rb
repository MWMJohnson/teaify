class TeaSerializer
  include JSONAPI::Serializer
  attributes  :title,
              :description,
              :temperature,
              :brew_time_seconds
end
