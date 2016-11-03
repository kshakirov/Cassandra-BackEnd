module TurboCassandra
  class TurboCluster
    @@session = nil

    def self.get_session
      if @@session.nil?
        @@session = create_cluster
      else
        @@session
      end
    end

    def self.get_mode
      ENV['TURBO_MODE']
    end

    def self.config config_data
      @@hosts = config_data['hosts']
      @@keyspace = config_data['keyspace']
    end

    def self.read_config
      config = YAML::load_file(File.expand_path('../../../config/database.yml', File.dirname(__FILE__)))
      mode = get_mode
      if not mode.nil?
          config config[mode]
      else
        puts "SET TURBO_MODE variable "
        exit 1
      end
    end

    def self.create_cluster
      read_config
      cluster =Cassandra.cluster(hosts: @@hosts)
      cluster.connect(@@keyspace)
    end

    def self.get_keyspacse
      p File.dirname(__FILE__)
      p __dir__ + '../../config'

      filename = File.expand_path('../../../config/database.yml', File.dirname(__FILE__))
      p filename
      config = YAML::load_file( filename)
      mode = get_mode
      unless mode.nil?
          return config[mode]['keyspace']
      end
      puts "SET TURBO_MODE variable "
      exit 1
    end
  end
end