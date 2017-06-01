module TurboCassandra
  module Model
    module SystemModel
      class BaseSystemModule

        class << self
          attr_accessor :collection
        end

        # class << self
        #   ArangoServer.default_server user: "root", password: "servantes", server: "localhost", port: "8529"
        # end

        def self.class_name
          self.to_s.tableize.gsub("turbo_cassandra/model/system_model/", '')
        end

        def self.init
          ArangoServer.default_server user: "root", password: "servantes", server: "localhost", port: "8529"
          self.collection = ArangoCollection.new database: "TurboArrango", collection: "#{class_name}"
        end

        def self.all
          if self.collection.nil?
            init
          end
          self.collection.allDocuments
        end

        def self.create data_hash
          if self.collection.nil?
            init
          end
          self.collection.create_document document: data_hash
        end

        def self.delete data_index_hash
          if self.collection.nil?
            init
          end
          self.collection.removeMatch match: data_index_hash
        end

        def self.find index_hash
          if self.collection.nil?
            init
          end
          self.collection.documentMatch match: index_hash
        end
      end
    end
  end
end