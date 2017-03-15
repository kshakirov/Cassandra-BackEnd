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

end