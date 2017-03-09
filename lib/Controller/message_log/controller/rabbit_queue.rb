module TurboCassandra
  module Controller
    class RabbitQueue
      attr_reader :connection
      def initialize rabbit_host
        @connection = MarchHare.connect(:hostname => rabbit_host)
      end
    end
  end
end