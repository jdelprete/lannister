require 'httparty'
require 'nokogiri'
require 'watir'

class ProductsController < ApplicationController
  protect_from_forgery prepend: true
  skip_before_action :set_layout_variables, only: [:create, :import]

  def create
    product_url = params[:url]
    Product.create_from_url(product_url)
  end

  def import_index
    @products = Product.where(shopify_id: nil)
  end

  def import
    product = Product.find(params[:id])

    product.images = product.images.where(id: params[:images]) unless params[:images].blank?
    product.product_variants = product.product_variants.where(id: params[:variants]) unless params[:variants].blank?

    res = product.import # TODO check res
  end

  def search
    query = params[:query]

    render :json => [] and return if query.blank?

    products = Product.where("title ILIKE ?", "%#{query}%")

    results = products.map do |product|
      {
        id: product.id,
        title: product.title,
        image_src: product.primary_image.url,
        variants: product.product_variants.map do |variant|
          { id: variant.id, title: variant.title, image_src: variant.image.url, cost: variant.cost }
        end
      }
    end

    render :json => results
  end
end
