module TurboCassandra
  module Controller
    module TemplateNotification
      def create_notification_template request, root
        template = ""
        data = {}
        case request['notification_code']
          when 'send_user_data'
            template = read_template root, 'send_user_data.html.erb'
            data = request['data']
          else

        end
        renderer = ERB.new(template)
        {
            file: renderer.result(binding),
            action: 1
        }
      end
    end
  end
end