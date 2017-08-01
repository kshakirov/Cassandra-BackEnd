require_relative '../../test_helper'


class TestProductCreatedAt < Minitest::Test
  def setup

  end

  def test_insert

  end

  def test_select
    params = {
    "manufacturer" => 'Turbo International',
    "part_type" => 'Backplate'
    }
    paginate_state = {
        "paging_state" => nil,
        "page_size" => 5
    }
    res =  TurboCassandra::Model::ProductCreatedAt.paginate paginate_state, params
    refute_nil res
    assert_equal 5, res[:results].size
    paging = res[:paging_state]
    res =  TurboCassandra::Model::ProductCreatedAt.paginate paginate_state, params
    assert_equal 5, res[:results].size
  end

end



