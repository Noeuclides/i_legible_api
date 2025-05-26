FactoryBot.define do
  factory :lesson do
    association :user
    sequence(:title) { |n| "Lesson #{n}" }
    sequence(:summary) { |n| "Summary for lesson #{n}" }
    taken_on { Date.current }

    trait :with_vocabulary_entries do
      after(:create) do |lesson|
        create_list(:vocabulary_entry, 3, lesson: lesson, user: lesson.user)
      end
    end
  end
end 