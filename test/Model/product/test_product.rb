require_relative '../test_helper'


class TestCustomer < Minitest::Test

  def test_find
    product = TurboCassandra::Model::Product.find 1
    refute_nil product
    assert_equal "700177-0001", product.part_number
  end

  def test_paging
    paging_params = {
        'page_size' => 5,
        'paging_state' => nil
    }
    res = TurboCassandra::Model::Product.paginate paging_params
    assert_equal false, res[:last]
  end
end



