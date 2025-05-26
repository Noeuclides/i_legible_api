class ResourceItem < ApplicationRecord
  belongs_to :attachable, polymorphic: true
  has_one_attached :file
end
