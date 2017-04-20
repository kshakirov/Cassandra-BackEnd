module TurboCassandra
  module Controller
    class MessageLog
      include MessageLogPagination
      private
      def prepare_queue rabbit_conn, queue
        channel = rabbit_conn.create_channel
        channel.queue(queue)
      end

      def prepare_incoming_message customer_email, message
        {
            customer_email: customer_email,
            message: message,
            status: 'Queued'
        }
      end

      def prepare_outcoming_message request
        {
            message: request['message'],
            status: request['status'],
            date_end: Time.now.to_time
        }
      end

      def prepare_queue_payload email, action, message_id
        {
            "email": email,
            "action": action,
            "id": message_id.to_s
        }.to_json
      end

      def prepare_order_queue_payload request, message_id
        {
            "email": request['email'],
            "order_id": request['order_id'],
            "action": 'order',
            "id": message_id.to_s
        }.to_json
      end

      def log_task customer_email, message
        message_data = prepare_incoming_message(customer_email, message)
        @message_log_api.add_message(message_data)
      end

      def publish_task payload
        @channel.publish(payload, :routing_key => @queue)
      end

      def commit_log request
        message_data = prepare_outcoming_message(request)
        message_id = Cassandra::TimeUuid.new(request['id'])
        @message_log_api.update_message_by_id(request['email'],
                                              message_id, message_data)
        {
            result: true
        }
      end

      public
      def initialize (rabbit_conn, queue='customer_email')
        @message_log_api = TurboCassandra::API::MessageLog.new
        @queue = queue
        @channel = prepare_queue(rabbit_conn, queue)
      end

      def queue_password_reset_task read
        request = JSON.parse read
        message_id = log_task(request["email"], "Customer [#{request['email']}] Queued To Reset Password")
        queue_payload = prepare_queue_payload(request["email"], 'reset', message_id)
        publish_task(queue_payload)
      end


      def queue_order_task body
        request = JSON.parse body
        message_id = log_task(request["email"], "Order [#{request['order_id']}] Queued To Email")
        task_payload = prepare_order_queue_payload(request,message_id)
        publish_task(task_payload)
      end


      def log_task_complete body
        request_payload = JSON.parse body
        commit_log(request_payload)
      end

      def queue_new_customer_task read
        request = JSON.parse read
        message_id = log_task(request_payload["email"],'New Customer')
        queue_payload = prepare_queue_payload(request["email"], 'new', message_id)
        publish_task( queue_payload)
      end

      def log_new_customer_task read
        request_payload = JSON.parse read
        message = "New  Customer [#{request_payload['email']}],  new password   [ #{request_payload['password']}]"
        commit_log(request_payload)
      end

    end
  end

end