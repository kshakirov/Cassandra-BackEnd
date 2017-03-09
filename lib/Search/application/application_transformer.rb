module TurboCassandra
  class EsApplicationTransformer
    private
    def _create_id string
      Digest::MD5.hexdigest(string)
    end

    def _create_scheleton app
      {
          make: app['make'],
          model: app['model'],
          year: app['year'],
          engineSize: app['engineSize'],
          id: _create_id(app['string'])
      }
    end

    public
    def run app
      _create_scheleton(app)
    end
  end
end