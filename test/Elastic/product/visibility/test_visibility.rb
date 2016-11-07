require_relative "../test_helper"

class TestVisibility < Minitest::Test
  def setup
    @product = TurboCassandra::Product.new
    @visibility_manager = TurboCassandra::Visibility.new
  end

  def test_not_turbo
    # with ti interchangeinterchange and  notti manufactured
    p = @product.find  44765
    visibility = @visibility_manager.get_visibility(p.first)
     assert visibility
  end

  def test_not_turbo_2
    # without ti  interchange and  not ti manufactured
    p = @product.find  5636
    visibility = @visibility_manager.get_visibility(p.first)
    assert_equal false,  visibility
  end

  def test_turbo_without_ti_chra
    p = @product.find  6700
    visibility = @visibility_manager.get_visibility(p.first)
    assert_equal false,  visibility
  end

  def test_turbo_with_ti_chra
    p = @product.find  19191
    visibility = @visibility_manager.get_visibility(p.first)
    assert_equal true,  visibility
  end
end