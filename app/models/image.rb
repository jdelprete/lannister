class Image < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  has_one :product
end
