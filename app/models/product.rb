class Product < ApplicationRecord
  has_many :images

  def self.from_url(product_url)
    product = Product.new
    product.url = product_url.split('?').first

    browser = Watir::Browser.new(:phantomjs)
    browser.goto(product.url)
    browser.element(class: 'description-content').hover
    browser.element(css: '.description-content img').wait_until_present

    product_page = Nokogiri::HTML(browser.html)
    product.name = product_page.at_css('.product-name').text
    product_imgs = product_page.css('.description-content img')
    product_desc = product_page.css('.product-property-list li').reduce('') do |desc, li|
      key = li.at_css('.propery-title').text
      val = li.at_css('.propery-des').text
      desc + "<strong>#{key}</strong>: #{val}\n"
    end

    product.save
  end
end
