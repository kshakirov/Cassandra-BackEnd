require_relative '../test_helper'


class TestAttributeBatch < Minitest::Test

  def read_attributes_from_file
    fd = File.open(__dir__ + '../../../data/attribute.json', 'r')
    data = fd.read
    JSON.parse data
  end

  def setup
    @attribute_batch = TurboCassandra::Model::AttributeBatch.new
    @attributes = read_attributes_from_file
    @attribute_api = TurboCassandra::API::Attribute.new

  end
  def test_adopt
    result  = @attribute_batch.adopt_hash @attributes[0]
    refute_nil result
    @attribute_api.create result
  end


end