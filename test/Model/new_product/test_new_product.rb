require_relative '../test_helper'


class TestNewProdcut < Minitest::Test

  def test_get
    ids = TurboCassandra::Model::NewProduct.all
    assert  ids.size > 0
  end

  def test_add
    product_hash = {
        sku: 6413,
        visible: true,
        ord: 1,
        part_number: '1-A-2761'
    }
    new_product = TurboCassandra::Model::NewProduct.new product_hash
    new_product.save
  end

  def test_max_ord
    order = TurboCassandra::Model::FeaturedProductOrder.max(
        {
            'max' => 'ord',
            "by" => {
                "cluster":  1
            }})
    order.nil?  ? 1 : order + 1
    p order
  end



end