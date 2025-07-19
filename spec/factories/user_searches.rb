FactoryBot.define do
  factory :user_search do
    user_ip { Faker::Internet.ip_v4_address }
    final_query { Faker::Lorem.sentence(word_count: 4) }
    search_count { Faker::Number.between(from: 1, to: 10) }

    trait :frequent_searcher do
      search_count { Faker::Number.between(from: 50, to: 100) }
    end

    trait :new_searcher do
      search_count { 1 }
    end
  end
end
