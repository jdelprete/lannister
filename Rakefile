# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

task :clean => :environment do
  ProductVariant.destroy_all
  VariantOption.destroy_all
  Product.destroy_all
  Order.destroy_all

  puts 'db emptied'
end

task :get_all_orders, [:user_id] => :environment do |t, args|
  user = User.find(args[:user_id])
  ShopifyAPI::Base.site = user.store_api_url

  last_order = user.orders.order('shopify_order_number DESC').first

  orders_added = 0

  ShopifyAPI::Order.all.each do |shopify_order|
    break if last_order && last_order.shopify_order_number >= shopify_order.number

    o = Order.create_from_shopify_order(shopify_order, user)
    orders_added += 1 unless o.nil?
  end

  puts "fetched #{orders_added} orders"
end
