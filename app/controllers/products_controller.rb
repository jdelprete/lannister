require 'httparty'
require 'nokogiri'
require 'watir'

class ProductsController < ApplicationController
  protect_from_forgery prepend: true

  def index
    @products = Product.all
  end

  def create
    product_url = params[:url]
    Product.from_url(product_url)
  end
end
