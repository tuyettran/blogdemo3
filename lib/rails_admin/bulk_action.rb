require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class BulkToggleBase < RailsAdmin::Config::Actions::Base
        # Is the action acting on the root level (Example: /admin/contact)
        register_instance_option :collection? do
          true
        end

        register_instance_option :bulkable? do
          true
        end

        register_instance_option :link_icon do
          'icon-move'
        end

        register_instance_option :http_methods do
          [:post]
        end
      end

      class BulkToggle < RailsAdmin::Config::Actions::BulkToggleBase
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :controller do
          Proc.new do |klass|
            @objects = list_entries(@model_config, :toggle)
            @objects.each do |obj|
              obj.update_attributes enabled: !obj.enabled
            end
            redirect_back
          end
        end
      end

      class BulkEnable < RailsAdmin::Config::Actions::BulkToggleBase
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :controller do
          Proc.new do |klass|
            @objects = list_entries(@model_config, :toggle)
            @objects.each do |obj|
              obj.update_attributes enabled: true
            end
            redirect_back
          end
        end
      end

      class BulkDisable < RailsAdmin::Config::Actions::BulkToggleBase
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :controller do
          Proc.new do |klass|
            @objects = list_entries(@model_config, :toggle)
            @objects.each do |obj|
              obj.update_attributes enabled: false
            end
            redirect_back
          end
        end
      end
    end
  end
end
