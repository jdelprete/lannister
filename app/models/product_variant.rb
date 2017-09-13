class ProductVariant < ApplicationRecord
  has_one :image, as: :imageable
  belongs_to :product
  has_and_belongs_to_many :variant_options
end
