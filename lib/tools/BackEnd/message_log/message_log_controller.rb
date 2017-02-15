module TurboCassandra
  module Controller
    class MessageLog
      private
      def prepare_queue rabbit_conn, queue
        channel = rabbit_conn.create_channel
        channel.queue(queue)
      end

      def prepare_incoming_message request_payload, admin_email
        {
            sender_email: request_payload['email'],
            recepient_email: admin_email,
            message: "Reset Password"
        }
      end

      def prepare_outcoming_message request_payload, admin_email
        {
            sender_email: admin_email,
            recepient_email:  request_payload['email'],
            message: "New  Password " + request_payload['password']
        }
      end

      def prepare_queue_payload_reset  email
          {
              "email": email,
              action: "reset"
          }.to_json
      end

      public
      def initialize (rabbit_conn, queue='customer_email')
        @message_log_api = TurboCassandra::API::MessageLog.new
        @queue = queue
        @channel = prepare_queue(rabbit_conn, queue)
      end

      def add_password_reset_msg read, admin_email
        request_payload = JSON.parse read
        message_data = prepare_incoming_message(request_payload, admin_email)
        @message_log_api.add_message(message_data)
        @channel.publish(prepare_queue_payload_reset(request_payload["email"]), :routing_key => @queue)
      end

      def add_password_sent_msg read, admin_email
        request_payload = JSON.parse read
         message_date = prepare_outcoming_message(request_payload, admin_email)
        @message_log_api.add_message(message_date)
      end
    end
  end

end