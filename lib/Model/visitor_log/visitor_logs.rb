module TurboCassandra
  module Model
    class VisitorLog < BaseModel
    end
    VisitorLog.primary_index = %W(visitor_id date id ip)
  end
end