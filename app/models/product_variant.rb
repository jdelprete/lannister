class ProductVariant < ApplicationRecord
  belongs_to :product
  belongs_to :image, optional: true
  has_and_belongs_to_many :variant_options

  def sorted_variant_options
    self.variant_options.sort_by { |o| o.category }
  end

  def title
    self.sorted_variant_options.map { |o| o.category }.join('/')
  end
end
