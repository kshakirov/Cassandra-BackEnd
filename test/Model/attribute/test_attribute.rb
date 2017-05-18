require_relative '../test_helper'


class TestAttributeSet < Minitest::Test
  def setup


  end
  def test_by_codes
    attributes = TurboCassandra::Model::Attribute.find_in_by code:  ['bltscrwDiagram','bltscrwWeight', 'bltscrwSpecialfeaturesonoff']
    refute_nil attributes
  end

  def test_find
    code = 'brnghsngWatercooled'
    attribute = TurboCassandra::Model::Attribute.find code
    assert_equal 'brnghsngWatercooled',attribute.code
  end

  def test_delete
    code = 'brnghsngWatercooled'
    TurboCassandra::Model::Attribute.delete code
  end

end