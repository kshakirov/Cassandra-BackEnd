require_relative '../test_helper'


class TestCustomer < Minitest::Test
  def setup
  end

  def test_get
    featured_products=TurboCassandra::Model::FeaturedProduct.all
    assert_equal 2 , featured_products.size
  end

  def test_add_fp

     featured_product = TurboCassandra::Model::FeaturedProduct.new(
         {sku: 68674, visible: true, ord: 1, part_number: '1-C-6613' })

    featured_product.save

     featured_product = TurboCassandra::Model::FeaturedProduct.new(
         {sku: 63547, visible: true, ord: 2, part_number: '1-A-6022' })

     featured_product.save

     featured_product = TurboCassandra::Model::FeaturedProduct.new(
         {sku: 63563, visible: true, ord: 3, part_number: '1-A-6021' })

     featured_product.save
  end

  def test_add_fp_ord

    featured_product = TurboCassandra::Model::FeaturedProductOrder.new(
        {sku: 68674, visible: true, ord: 1, ord_cluster: 1, part_number: '1-C-6613' })

    featured_product.save

    featured_product = TurboCassandra::Model::FeaturedProductOrder.new(
        {sku: 63547, visible: true, ord: 2, part_number: '1-A-6022' })

    featured_product.save

    featured_product = TurboCassandra::Model::FeaturedProductOrder.new(
        {sku: 63563, visible: true, ord: 3, part_number: '1-A-6021' })

    featured_product.save
  end

  def test_change_visibility_order
    featured_product = TurboCassandra::Model::FeaturedProduct.find 63563
    featured_product_order = TurboCassandra::Model::FeaturedProductOrder.find featured_product.ord
    featured_product_order.visible= false
    featured_product_order.save
    featured_product.visible= false
    featured_product.save
  end

  def test_find_visible
    featured_products=TurboCassandra::Model::FeaturedProductOrder.find_by visible: true
    assert_equal 2 , featured_products.size
  end


  def test_delete
    TurboCassandra::Model::FeaturedProductOrder.delete  1, 100
  end

  def test_max
    max = TurboCassandra::Model::FeaturedProductOrder.max({'max' => 'ord', "by" => {
        "cluster": 1
    }})
    refute_nil max
  end

end