class AliexpressShop < ApplicationRecord
  has_many :products

  def url
    "https://www.aliexpress.com/store/#{ali_store_id}"
  end
end
