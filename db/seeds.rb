# Clear existing data (use with caution in dev only)
User.destroy_all
WordType.destroy_all
Lesson.destroy_all
VocabularyEntry.destroy_all
ResourceItem.destroy_all

puts "Seeding Word Types..."
word_types = %w[
  Noun Verb Adjective Adverb Preposition Conjunction Interjection
  Pronoun Article Determiner Numeral Particle Expression Phrase
].map do |name|
  WordType.create!(name: name)
end

puts "Creating test user..."
user = User.create!(
  email: "test@example.com",
  password: "password123",
  password_confirmation: "password123"
)

puts "Creating lessons..."
lesson1 = Lesson.create!(
  user: user,
  title: "Daily Routine Vocabulary",
  summary: "Basic verbs and nouns for everyday activities.",
  taken_on: Date.today - 5
)

lesson2 = Lesson.create!(
  user: user,
  title: "Common Prepositions",
  summary: "List of most used prepositions in daily speech.",
  taken_on: Date.today - 2
)

puts "Creating vocabulary entries..."
vocab1 = VocabularyEntry.create!(
  user: user,
  word: "gehen",
  translation: "to go",
  context: "Ich gehe zur Arbeit.",
  word_type: WordType.find_by(name: "Verb"),
  lesson: lesson1
)

vocab2 = VocabularyEntry.create!(
  user: user,
  word: "Tisch",
  translation: "table",
  context: "Der Tisch ist groß.",
  word_type: WordType.find_by(name: "Noun"),
  lesson: lesson2
)

vocab3 = VocabularyEntry.create!(
  user: user,
  word: "unter",
  translation: "under",
  context: "Der Ball ist unter dem Tisch.",
  word_type: WordType.find_by(name: "Preposition"),
  lesson: nil
)

vocab4 = VocabularyEntry.create!(
  user: user,
  word: "obwohl",
  translation: "although",
  context: "Ich gehe spazieren, obwohl es regnet.",
  word_type: WordType.find_by(name: "Conjunction"),
  lesson: nil
)

puts "Creating resource items..."
ResourceItem.create!(
  attachable: lesson1,
  url: "https://deutsch.example.com/daily-routine-verbs"
)

ResourceItem.create!(
  attachable: vocab3,
  url: "https://deutsch.example.com/prepositions-guide"
)

puts "✅ Done seeding!"
