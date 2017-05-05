module TurboCassandra
  module Controller
    class Template
      include TemplateNotification

      def initialize
        @order_api = TurboCassandra::API::Order.new
        @customer_api = TurboCassandra::API::Customer.new
        @templates = {
            notification: 'notification.html.erb',
            order: 'place_order.html.erb'
        }
      end

      private
      def calculate_path root, filename
        root.gsub("rest/turbo", "") + 'views/mailer/' + filename
      end

      def create_order_data order_id
        order = @order_api.find_by_id(order_id)
        customer = @customer_api.find_by_customer_id(order.first['customer_id'])
       return order.first, customer.to_hash
      end

      def create_order_template  request, root
        template = read_template root, @templates[:order]
        order_id = request['order_id']
        @order, @customer = create_order_data(order_id)
        renderer = ERB.new(template)
        {
            file: renderer.result(binding),
            action: 1
        }
      end

      def read_template root, filename
        template_filename = calculate_path(root, filename)
        File.read(template_filename)
      end

      def create_forgotten_pass_template request, root
        template = read_template root, @templates[:notification]
        email, password = request['email'], request['password']
        renderer = ERB.new(template)
        {
            file: renderer.result(binding),
            action: 1
        }
      end

      public
      def load root, params
        content = {type: 'html'}
        filename = calculate_path(root, params['name'])
        content[:file] = File.read(filename)
        content['filename'] = filename
        content
      end

      def save body
        file_object = JSON.parse body
        IO.write(file_object['filename'], file_object['file'])
      end

      def preview body
        file_object = JSON.parse body
        if file_object['filename'].include?  'place_order.html.erb'
          @order, @customer = create_order_data(100000001)
          renderer = ERB.new(file_object['file'])
          {
              file: renderer.result(binding)
          }
        elsif file_object['filename'].include? 'notification'
            email, password = "kshakirov@zoral.com.ua", "1212fdfdfe454545"
            server = "Turbointernational.com"
            renderer = ERB.new(file_object['file'])
            {
                file: renderer.result(binding)
            }
        end
      end

      def process body, root
        request = JSON.parse body
        if request['action'] == 'forgotten_password'
            create_forgotten_pass_template(request, root)
        elsif request['action'] == 'order'
          create_order_template(request, root)
        elsif request['action'] =='notification'
           create_notification_template(request, root)
        else
          {
              action: nil
          }
        end
      end

    end
  end
end