module TurboCassandra
  module Controller
    class Template
      include TemplateNotification
      include TemplatePreview
      include ActionView::Helpers::NumberHelper


      def initialize
        @order_api = TurboCassandra::API::Order.new
        @customer_api = TurboCassandra::API::Customer.new
        @admin_email_api = TurboCassandra::API::AdminEmail.new
        @notification_api = TurboCassandra::API::Notification.new
      end

      private

      def create_order_data order_id
        order = @order_api.find_by_id(order_id)
        customer = @customer_api.find_by_customer_id(order['customer_id'])
       return order, customer.to_hash
      end

      def prep_response template, sender_email, sender_name, template_data
        {
            file: template,
            action: 1,
            admin_email: sender_email,
            admin_name: sender_name,
            subject: add_subject(template_data)
        }
      end

      def create_order_template  request
        template_data = get_template('order')
        sender_name, sender_email = get_admin_email_data(template_data)
        order_id = request['order_id']
        @order, @customer = create_order_data(order_id)
        renderer = ERB.new(template_data.template_name)
        prep_response(renderer.result(binding), sender_email, sender_name,
        template_data)
      end

      def create_forgotten_pass_template request
        template_data = get_template('forgotten_password')
        email, password = request['email'], request['password']
        sender_name, sender_email = get_admin_email_data(template_data)
        renderer = ERB.new(template_data.template_name)
        prep_response(renderer.result(binding), sender_email, sender_name,
        template_data)
      end

      def get_admin_email_data template_data
        admin_email = @admin_email_api.get template_data.admin_email_code
        return admin_email.sender_name, admin_email.sender_email
      end

      def get_template code
        @notification_api.get code
      end

      public
      def load params
        template_data = get_template(params['name'])
        {
            type: 'html',
            file: template_data.template_name,
            data: template_data.data,
            filename: params['name'],
            admin_email: @admin_email_api.get(template_data.admin_email_code).to_hash

        }
      end

      def save body
        file_object = JSON.parse body
        notification = @notification_api.get file_object['filename']
        notification.template_name = file_object['file']
        notification.admin_email_code = file_object['admin_email']['code']
        notification.data = file_object['data']
        notification.save
      end

      def process body
        request = JSON.parse body
        if request['action'] == 'forgotten_password'
            create_forgotten_pass_template(request)
        elsif request['action'] == 'order'
          create_order_template(request)
        elsif request['action'] =='notification'
           create_notification_template(request)
        else
          {
              action: nil
          }
        end
      end
      def preview body
        _preview body
      end

    end
  end
end