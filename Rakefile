# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

task :clean => :environment do
  ProductVariant.destroy_all
  VariantOption.destroy_all

  Product.all.each { |p| p.primary_image = nil ; p.save}

  Image.destroy_all
  Product.destroy_all

  Order.destroy_all
  LineItem.destroy_all

  puts 'db emptied'
end
