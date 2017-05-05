module TurboCassandra
  module Controller
    class User
      include TurboCassandra::Controller::PasswordHash
      include UserNotification
      private
      def process_pass user_hash
        unless user_hash['password'].nil?
          user_hash['password'] = _hash_password(user_hash['password']).to_s
        end
      end

      def is_login_unique? login
          user = @user_api.find_user_by_login login
          if user.nil?
            return true
          end
          raise "User With This Login already exists"

      end

      def send_email? user_hash
          user_hash['send_data_2_user']
      end

      def is_updated_login_unique? user_hash
        user = @user_api.find_user_by_login user_hash['login']
        if user.nil? or  user['id'].to_s  == user_hash['id']
          return true
        end
        raise "User With This Login already exists"
      end

      def add_id user_hash
        user_hash['id'] = @generator.uuid
      end

      def coerce_id user_hash
        user_hash['id'] =  Cassandra::Uuid.new(user_hash['id'])
      end

      public
      def initialize
        @user_api = API::User.new
        @generator = Cassandra::Uuid::Generator.new
        @message_log_api = TurboCassandra::API::MessageLog.new
      end

      def get_users_list
        @user_api.all
      end

      def get_user params
        login = params['login']

        user = @user_api.find_user_by_login login
        user.to_hash
      end

      def delete_user params
        id = Cassandra::Uuid.new(params['id'])
        @user_api.delete_user id
      end

      def create_user user_hash
        if is_login_unique? user_hash['login']
          add_id(user_hash)
          process_pass(user_hash)
          @user_api.add_user user_hash
        end
      end

      def update_user user_hash
        if is_updated_login_unique? user_hash
          coerce_id(user_hash)
          process_pass(user_hash)
          @user_api.add_user user_hash
        end
      end

      def get_profile env
        name = ''
        image_id = ''
        if env.key? :group
          name = env[:name]
          image_id = env[:id]
        elsif env.key? 'customer'
          name = env['name']
          image_id = env['id']
        end
        {
            image_id: image_id,
            name: name

        }
      end

    end
  end
end