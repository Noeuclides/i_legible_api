FactoryBot.define do
  factory :word_type do
    sequence(:name) { |n| ["noun", "verb", "adjective", "adverb", "preposition"][n % 5] }
  end
end 