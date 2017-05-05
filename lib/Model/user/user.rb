module TurboCassandra
  module Model
    class User < BaseModel
      def save
        super
        true
      end
    end
    User.primary_index  = ['id']
  end
end