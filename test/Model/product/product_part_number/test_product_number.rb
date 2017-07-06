require_relative '../../test_helper'


class TestProductCreatedAt < Minitest::Test
   def test_new
        pn_prod = TurboCassandra::Model::ProductPartNumber.new part_number: "1-A-0549", sku: 6228
        pn_prod.save
   end

  def test_find
      pn_prod = TurboCassandra::Model::ProductPartNumber.find "1-A-0549"
     assert_equal 6228, pn_prod.sku
  end

  def test_delete
    assert TurboCassandra::Model::ProductPartNumber.delete "1-A-0549"
  end

end

