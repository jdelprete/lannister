class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def store_url
    "https://#{shopify_store_name}.myshopify.com/admin"
  end

  def store_api_url
    "https://#{api_key}:#{api_password}@#{shopify_store_name}.myshopify.com/admin"
  end
end
