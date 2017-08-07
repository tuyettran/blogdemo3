require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class ToggleBase < RailsAdmin::Config::Actions::Base
        register_instance_option :bulkable? do
          true
        end

        register_instance_option :http_methods do
          [:post]
        end
      end

      class Enable < RailsAdmin::Config::Actions::ToggleBase
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

      class ToggleEnable < RailsAdmin::Config::Actions::ToggleBase
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

      class Disable < RailsAdmin::Config::Actions::ToggleBase
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
