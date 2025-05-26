FactoryBot.define do
  factory :vocabulary_entry do
    association :user
    association :word_type
    lesson { nil }
    sequence(:word) { |n| "Word #{n}" }
    sequence(:translation) { |n| "Translation #{n}" }
    sequence(:context) { |n| "Context for word #{n}" }

    trait :with_lesson do
      association :lesson
    end
  end
end
