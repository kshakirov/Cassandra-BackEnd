task default: %w[db_setup]

task :db_setup do
  ruby "tools/schema/attribute/create_attributes.rb"
  ruby "tools/schema/attribute/add_attribute_set_index.rb"
  ruby "tools/schema/attribute/insert_default_attributes.rb"
  ruby "tools/schema/attribute_set/create_attribute_sets.rb"
  ruby "tools/schema/currency/create_currencies.rb"
  ruby "tools/schema/featured_product/create_featured_products.rb"
  ruby "tools/schema/new_product/create_new_products.rb"
  ruby "tools/schema/product/create_products.rb"
  ruby "tools/schema/product/add_interchange_column.rb"
  ruby "tools/schema/customer/create_customers.rb"
  ruby "tools/schema/customer/add_email_index.rb"
  ruby "tools/schema/cart/create_carts.rb"
  ruby "tools/schema/group_price/create_group_price.rb"
  ruby "tools/schema/order/create_orders.rb"
  ruby "tools/schema/order/add_customer_index.rb"
end

task :db_clean do

end

task :db_populate do
  ruby "tools/fixtures/attribute/populate.rb"
  ruby "tools/fixtures/attribute_set/populate.rb"
  ruby "tools/fixtures/attribute_set/update_1.rb"
  ruby "tools/fixtures/customer/populate.rb"
  ruby "tools/fixtures/group_price/populate.rb"
  ruby "tools/fixtures/order/populate.rb"
  ruby "tools/fixtures/product/populate.rb"
  ruby "tools/fixtures/currency/populate.rb"
  ruby "tools/fixtures/featured_new_product/populate.rb"

end

namespace :elastic do
  task :create_index do
    ruby "tools/elastic/product/create_index.rb"
  end
  task :delete_index do
    ruby "tools/elastic/product/delete_index.rb"
  end
  task :index_product do
    ruby "tools/elastic/product/product_indexer.rb"
  end
end