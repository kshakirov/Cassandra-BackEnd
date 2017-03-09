module TurboCassandra
  class ApplicationManager

    def hash_apps apps
      apps.map { |app| Digest::MD5.hexdigest(app) }
    end

    def get_application product
      unless product['application_detail'].nil?
        apps = product['application_detail'].split('||')
        hash_apps apps
      end
    end
  end
end