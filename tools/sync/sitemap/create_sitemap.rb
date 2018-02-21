ENV['TURBO_MODE'] ='development'
require_relative '../sync_helper'

price_updater = TurboCassandra::Sync::Price::PriceUpdater.new
products =  price_updater.get_our_products
File.open("sitemap.txt","w"){|f|
    products.each do |p|
      f.puts "http://staging.turbointernational.com/part/sku/#{p['sku']}"
    end
}

