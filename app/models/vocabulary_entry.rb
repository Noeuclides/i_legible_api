class VocabularyEntry < ApplicationRecord
  belongs_to :lesson, optional: true
  belongs_to :user
  belongs_to :word_type

  has_many :resource_items, as: :attachable, dependent: :destroy

  validates :word, presence: true
  validates :translation, presence: true
  validates :word_type, presence: true
  validates :user, presence: true
end
