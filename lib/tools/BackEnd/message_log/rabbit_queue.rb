module TurboCassandra
  module Controller
    class RabbitConnection
      attr_reader
      def initialize rabbit_host
        @conn = MarchHare.connect(:hostname => rabbit_host)
      end
    end
  end
end