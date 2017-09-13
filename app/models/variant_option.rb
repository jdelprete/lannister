class VariantOption < ApplicationRecord
  has_and_belongs_to_many :product_variants
  belongs_to :product
end
