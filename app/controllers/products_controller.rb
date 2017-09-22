require 'httparty'
require 'nokogiri'
require 'watir'

class ProductsController < ApplicationController
  protect_from_forgery prepend: true

  def index
    @products = Product.where(shopify_id: nil)
  end

  def create
    product_url = params[:url]
    Product.create_from_url(product_url)
  end

  def import
    product = Product.find(params[:id])

    product.images = product.images.where(id: params[:images]) unless params[:images].blank?
    product.product_variants = product.product_variants.where(id: params[:variants]) unless params[:variants].blank?

    res = product.import # TODO check res
  end
end
