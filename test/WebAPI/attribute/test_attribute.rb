require_relative "../test_helper"
class TestAttribute < Minitest::Test

  def setup
    @attribute_web_api =TurboCassandra::WebAPI::Attribute::Attribute.new
  end

  def test_create
    file_content = IO.read('options_attribute.json')
    data = JSON.parse file_content
    response = @attribute_web_api.create data.to_json
    assert response
  end

  def test_delete
    params = {'attribute_code' => 'pimsOptions'}
    response = @attribute_web_api.delete params
    assert response
  end

  def test_get
    params = {'attribute_code' => 'pimsOptions'}
    response = @attribute_web_api.get params
    assert response
  end

  def test_bool_2_i
    result  = @attribute_web_api.bool_2_i true
    assert_equal 1, result
    result  = @attribute_web_api.bool_2_i false
    assert_equal 0, result
    result  = @attribute_web_api.bool_2_i nil
    assert_equal 0, result
  end

  def test_i_2_bool
    result  = @attribute_web_api.bool_2_i true
    assert_equal 1, result

  end

end