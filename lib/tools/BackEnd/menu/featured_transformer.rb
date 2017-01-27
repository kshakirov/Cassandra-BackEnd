module TurboCassandra
  class FeaturedTransformer
    def initialize
      @product_manager = Product.new
      @product_backend = TurboCassandra::ProductBackEnd.new
    end
    def _get_scheleton product
      {
          description: product['description'],
          name: product['name'],
          part_type: product['part_type'],
          url: "/#/part/sku/#{product['sku']}",
          image_url: "/imageserver/product/#{product['sku']}/image/215/165",
          price: nil,
          turbo_model: product['turbo_model'],
          turbo_type: product['turbo_type'],
          oe_ref_urls: []
      }
    end

    def _create_response products
      products.map{|p| _get_scheleton(p)}
    end

    def get_featured_products featureds
         #products = featureds.map{|f| @product_backend.f f['sku']}
         products = @product_backend.get_products(featureds.map{|f| f['sku']})
          _create_response(products)
    end
  end
end