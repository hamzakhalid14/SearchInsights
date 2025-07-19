FactoryBot.define do
  factory :search_query do
    user_ip { Faker::Internet.ip_v4_address }
    query_text { Faker::Lorem.sentence(word_count: 3) }
    is_complete { false }

    trait :complete do
      is_complete { true }
    end

    trait :incomplete do
      is_complete { false }
    end
  end
end
