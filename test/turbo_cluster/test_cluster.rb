require_relative 'test_helper'

class TestCluster < Minitest::Test
  def setup
  end

  def test_find
    cluster = TurboCassandra::TurboCluster.create_cluster
    refute_nil cluster
  end

  def test_find_2
    path = TurboCassandra::TurboCluster.get_keyspacse
    refute_nil cluster
  end
end