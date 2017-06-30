module TurboCassandra
  module Controller
    class VisitorLog
      def initialize rabbit_conn, queue
        @visitor_log_api = TurboCassandra::API::VisitorLog.new
        @queue = queue
        channel = rabbit_conn.create_channel
        @channel = channel.queue(@queue)
      end

      private

      def prepare_visit_data request
        request.body.rewind
        payload = JSON.parse request.body.read
        {
            visitor_id: request.env['HTTP_X_VISITOR'].to_i,
            ip: request.env['REMOTE_ADDR'],
            product: payload['sku'].to_i,
        }
      end

      def prepare_customer_visit_data request, params
        customer_id = request.env.values_at(:customer).first['id']
        sku = params[:id].to_i
         {
            customer_id: customer_id,
            ip: request.env['REMOTE_ADDR'],
            product: sku
        }
      end

      def prep_queue_payload visitor_log
        {
            type: 'visitor_logs',
            data: {
                visitor_id: visitor_log[:visitor_id],
                date: (visitor_log[:date].to_f * 1000).to_i,
                id:  visitor_log[:id].to_s,
                ip: visitor_log[:ip].to_s
            }
        }
      end

      def make_stats visitor_log
            payload = prep_queue_payload visitor_log
            @channel.publish(payload.to_json, :routing_key => @queue)
      end

      public
      def new_visit request
        visitor_log = @visitor_log_api.create(prepare_visit_data(request))
        make_stats visitor_log
      end

      def last_5_visits request
        id = request.env['HTTP_X_VISITOR'].to_i
        @visitor_log_api.last_nth id, 5
      end

      def new_customer_visit request, params
        @visitor_log_api.create_customer_visit(prepare_customer_visit_data(request, params))
      end

      def last_5_customer_visits request
        id = request.env.values_at(:customer).first['id']
        @visitor_log_api.last_nth_customer id, 5
      end

    end
  end
end