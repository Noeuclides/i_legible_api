class WordType < ApplicationRecord
    has_many :vocabulary_entries, dependent: :nullify

    validates :name, presence: true, uniqueness: true
end
