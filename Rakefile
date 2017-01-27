namespace :db do
  namespace :migrate do
    task :currency do
      ruby "tools/schema/currency/update_currencies_1.rb"
      ruby "tools/schema/currency/update_currencies_2.rb"
    end
    task :attribute do
      ruby "tools/schema/attribute/update_attributes_1.rb"
      ruby "tools/schema/attribute/update_attributes_2.rb"
    end
    task :order do
      ruby "tools/schema/order/update_orders_1.rb"
    end
    task :attribute_set do
      ruby "tools/schema/attribute_set/update_attribute_sets_1.rb"
    end
    task :product do
      ruby "tools/schema/product/update_products_2.rb"
    end
    task :all do
      Rake::Task['db:migrate:currency'].execute
      Rake::Task['db:migrate:attribute'].execute
      Rake::Task['db:migrate:order'].execute
      Rake::Task['db:migrate:attribute_set'].execute
      Rake::Task['db:migrate:product'].execute

    end
  end
  namespace :setup do
    task :base do
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
    task :visitor_log do
      ruby "tools/schema/visitor_log/create_visitor_log.rb"
      ruby "tools/schema/visitor_log/create_customer_log.rb"
    end

    task :all do
      Rake::Task['db:setup:base'].execute
      Rake::Task['db:setup:visitor_log'].execute
    end
  end

  namespace :populate do
    task :product do
      ruby "tools/fixtures/product/populate.rb"
    end
    task :all do
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
  end
end
namespace :elastic do
  task :create_index do
    ruby "tools/elastic/product/create_index.rb"
    ruby "tools/elastic/product/put_mapping.rb"
  end
  task :delete_index do
    ruby "tools/elastic/product/delete_index.rb"
  end
  task :map do
    ruby "tools/elastic/product/put_mapping.rb"
    ruby "tools/elastic/application/put_mapping.rb"
  end
  task :index_product do
    ruby "tools/elastic/product/product_indexer.rb"
  end
  task :index_application do
    ruby "tools/elastic/application/application_indexer.rb"
  end
end