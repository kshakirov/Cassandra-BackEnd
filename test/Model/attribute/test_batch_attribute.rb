require_relative 'test_helper'


class TestAttributeBatch < Minitest::Test
  def setup
    @attribute_batch = TurboCassandra::AttributeBatch.new
    @attributes = read_attributes_from_file
    @attribute = TurboCassandra::Attribute.new

  end
  def test_adopt
    result  = @attribute_batch.adopt_hash @attributes[0]
    refute_nil result
    names, values, args = @attribute.insert result
   # assert_equal args.size, names.size
  end


end