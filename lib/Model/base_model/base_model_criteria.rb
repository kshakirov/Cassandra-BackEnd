module TurboCassandra
  class Criteria
    def initialize(klass)
      @klass = klass
    end


    def criteria
      @criteria ||= {:conditions => {}}
    end

    def where(args)
      criteria[:conditions].merge!(args)
      self
    end

    def limit(limit)
      criteria[:limit] = limit
      self
    end

    def last
      @klass.last(
          criteria[:conditions], {:limit => criteria[:limit]}
      )
    end

  end
  class BaseModel


    def self.get_criteria

    end


    def self.where args
      Criteria.new(self).where(args)
     end

    def self.limit args
      Criteria.new(self).limit(args)
    end

    def self.each

    end

  end
end