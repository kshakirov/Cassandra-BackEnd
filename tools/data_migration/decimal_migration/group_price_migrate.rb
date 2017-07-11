require_relative '../current_helper'
group_price_api = TurboCassandra::API::GroupPrice.new
group_price_api.all.each do |price|
  unless price['standardprice'].nil?
    price['standardprice'] = BigDecimal.new (price['standardprice']).round(3)
    price['prices'].each do |k, v|
      price['prices'][k] = BigDecimal.new (v).round(3) unless v.nil?
    end
    group_price_api.create price
  end
end
