namespace :db do


  namespace :keyspace do
    task :create do
      ruby "tools/schema/system/create_keyspace.rb"
    end
  end

  namespace :migrate do
    task :currency do
      ruby "tools/schema/currency/update_currencies_1.rb"
      ruby "tools/schema/currency/update_currencies_2.rb"
    end
    task :attribute do
       ruby "tools/schema/attribute/update_attributes_1.rb"
       ruby "tools/schema/attribute/update_attributes_2.rb"
      ruby "tools/schema/attribute/update_attributes_3.rb"
    end
    task :attribute_set do
      ruby "tools/schema/attribute_set/update_attribute_sets_1.rb"
    end
    task :customer do
      ruby "tools/schema/customer/add_email_index.rb"
    end

    task :product do
      ruby "tools/schema/product/update_products_1.rb"
    end

    task :user do
      ruby "tools/schema/user/update_user_1.rb"
      ruby "tools/schema/user/update_user_2.rb"
    end

    task :all do
      Rake::Task['db:migrate:currency'].execute
      Rake::Task['db:migrate:attribute'].execute
      Rake::Task['db:migrate:order'].execute
      Rake::Task['db:migrate:attribute_set'].execute
      Rake::Task['db:migrate:customer'].execute
      Rake::Task['db:migrate:product'].execute
    end
  end
  namespace :setup do
    task :base do
      ruby "tools/schema/attribute/create_attributes.rb"
      ruby "tools/schema/attribute/add_attribute_set_index.rb"
      ruby "tools/schema/attribute_set/create_attribute_sets.rb"
      ruby "tools/schema/currency/create_currencies.rb"
      ruby "tools/schema/customer/create_customers.rb"

    end

    task :order do
      ruby "tools/schema/order/create_orders.rb"
    end

    task :group_price do
      ruby "tools/schema/group_price/create_group_price.rb"
    end

    task :pims_attribute do
      ruby "tools/schema/attribute/create_attributes.rb"
      ruby "tools/schema/attribute/add_attribute_set_index.rb"
    end

    task :pims_attribute_set do
      ruby "tools/schema/attribute_set/create_attribute_sets.rb"
      ruby "tools/schema/attribute_set/update_attribute_sets_1.rb"
    end

    task :new_product do
      ruby "tools/schema/new_product/create_new_products.rb"
    end

    task :product do
      ruby "tools/schema/product/create_products.rb"
    end

    task :product_created_at do
      ruby "tools/schema/product/product_created_at/create_product_created_at.rb"
    end

    task :visitor_log do
      ruby "tools/schema/visitor_log/create_visitor_log.rb"
      ruby "tools/schema/visitor_log/create_customer_log.rb"
    end

    task :compared_products do
      ruby "tools/schema/compared_products/create_compared_products.rb"
    end
    task :message_log do
      ruby "tools/schema/message_log/create_message_log.rb"
      ruby "tools/schema/message_log/add_index.rb"
    end

    task :shipment do
      ruby "tools/schema/order/create_shipments.rb"
    end

    task :currency_history do
      ruby "tools/schema/currency/create_currency_history.rb"
    end

    task :cart do
      ruby "tools/schema/cart/create_carts.rb"
    end

    task :customer_group do
      ruby "tools/schema/customer_group/create_customer_group.rb"
    end

    task :invoice do
      ruby "tools/schema/invoice/create_invoice_product.rb"
      ruby "tools/schema/invoice/create_product_invoice.rb"
      ruby "tools/schema/invoice/create_also_bought_product.rb"
    end

    task :user do
      ruby "tools/schema/user/create_user.rb"
    end

    task :authentication_node do
      ruby "tools/schema/authentication_node/create_authentication_node.rb"
    end

    task :admin_email do
      ruby "tools/schema/admin_email/create_admin_email.rb"
    end

    task :notification do
      ruby "tools/schema/notification/create_notification.rb"
    end

    task :featured_product do
      ruby "tools/schema/featured_product/create_featured_products.rb"
    end

    task :bot do
      ruby "tools/schema/bot/create_bots.rb"
    end

    task :product_rank do
      ruby "tools/schema/product/product_rank/create_product_ranks.rb"
    end

    task :all do
      Rake::Task['db:setup:base'].execute
      Rake::Task['db:setup:cart'].execute
      Rake::Task['db:setup:order'].execute
      Rake::Task['db:setup:group_price'].execute
      Rake::Task['db:setup:visitor_log'].execute
      Rake::Task['db:setup:compared_products'].execute
      Rake::Task['db:setup:message_log'].execute
      Rake::Task['db:setup:order_product'].execute
      Rake::Task['db:setup:product'].execute
      Rake::Task['db:setup::product_created_at'].execute
      Rake::Task['db:setup:shipment'].execute
      Rake::Task['db:setup:currency_history'].execute
      Rake::Task['db:setup:new_product'].execute
      Rake::Task['db:setup:invoice'].execute
      Rake::Task['db:setup:customer_group'].execute
      Rake::Task['db:setup:user'].execute
      Rake::Task['db:setup:authentication_node'].execute
      Rake::Task['db:setup:admin_email'].execute
      Rake::Task['db:setup:notification'].execute
      Rake::Task['db:setup:featured_product'].execute
      Rake::Task['db:setup:bot'].execute
      Rake::Task['db:setup:product_rank'].execute
    end
  end

  namespace :populate do
    task :product do
      ruby "tools/fixtures/product/populate.rb"
    end

    task :customer do
      ruby "tools/fixtures/customer/populate.rb"
    end

    task :currency do
      ruby "tools/fixtures/currency/populate.rb"
    end

    task :order do
      ruby "tools/fixtures/order/populate.rb"
    end

    task :shipment do
      ruby "tools/fixtures/order/shipments_populate.rb"
    end

    task :attribute do
      ruby "tools/fixtures/attribute/populate.rb"
      ruby "tools/fixtures/attribute/insert_default_attributes.rb"
    end

    task :attribute_set do
      ruby "tools/fixtures/attribute_set/populate.rb"
      ruby "tools/fixtures/attribute_set/update_1.rb"
      ruby "tools/fixtures/attribute_set/update_2.rb"
    end

    task :price do
      ruby "tools/fixtures/group_price/populate.rb"
    end

    task :customer_group do
      ruby "tools/fixtures/customer_group/populate.rb"
    end

    task :authentication_node do
      ruby "tools/fixtures/authentication_node/populate.rb"
    end

    task :user do
      ruby "tools/fixtures/user/populate.rb"
    end

    task :admin_email do
      ruby "tools/fixtures/admin_email/populate.rb"
    end

    task :notification do
      ruby "tools/fixtures/notification/populate.rb"
    end

    task :featured_product do
      ruby "tools/fixtures/featured_new_product/populate.rb"
    end

    task :all do
      Rake::Task['db:populate:product'].execute
      Rake::Task['db:populate:customer'].execute
      Rake::Task['db:populate:currency'].execute
      Rake::Task['db:populate:order'].execute
      Rake::Task['db:populate:shipment'].execute
      Rake::Task['db:populate:attribute'].execute
      Rake::Task['db:populate:attribute_set'].execute
      Rake::Task['db:populate:price'].execute
      Rake::Task['db:populate:customer_group'].execute
      Rake::Task['db:populate:authentication_node'].execute
      Rake::Task['db:populate:user'].execute
      Rake::Task['db:populate:admin_email'].execute
      Rake::Task['db:populate:notification'].execute
      Rake::Task['db:populate:featured_product'].execute

    end
  end
end
namespace :search do
  task :create_index do
    ruby "tools/search/product/create_index.rb"
  end
  task :delete_index do
    ruby "tools/search/product/delete_index.rb"
  end
  task :map do
    ruby "tools/search/product/put_mapping.rb"
    ruby "tools/search/application/put_mapping.rb"
  end
  task :index_product do
    ruby "tools/search/product/product_indexer.rb"
  end
  task :index_application do
    ruby "tools/search/application/application_indexer.rb"
  end
end

namespace :sync do
  namespace :product do
    task :update do
      ruby "tools/sync/product/console/product_update.rb"
    end
    task :up do
      ruby "tools/sync/product/console/product_update.rb"
    end
  end
end
