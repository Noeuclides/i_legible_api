class Lesson < ApplicationRecord
  belongs_to :user

  has_many :vocabulary_entries, dependent: :destroy
  has_many :resource_items, as: :attachable, dependent: :destroy
end
