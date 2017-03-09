module TurboCassandra
  module API
    class MessageLog
      private
      def _add_message message_data
        message = {
            sender_email: message_data[:sender_email],
            recepient_email: message_data[:recepient_email],
            date: Time.now.to_time,
            id: @generator.uuid,
            message: message_data[:message]
        }
        @message_log_model.insert(message)
      end

      def _get_message_by_sender_email email
        @message_log_model.find_by_sender_email(email)
      end

      public
      def initialize
        @message_log_model = TurboCassandra::Model::MessageLog.new
        @generator = Cassandra::Uuid::Generator.new
      end

      def add_message message_data
        _add_message(message_data)
      end

      def get_message_by_sender_email  email
          _get_message_by_sender_email(email)
      end
    end
  end

end