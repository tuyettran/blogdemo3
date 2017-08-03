require Rails.root.join('lib', 'rails_admin', 'bulk_action.rb')

RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  config.authorize_with :cancan

  config.actions do
    dashboard
    index
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
    toggle
    bulk_toggle do
      visible do
        bindings[:abstract_model].model.to_s == "Post"
      end
    end
    bulk_enable do
      visible do
        bindings[:abstract_model].model.to_s == "Post"
      end
    end
    bulk_disable do
      visible do
        bindings[:abstract_model].model.to_s == "Post"
      end
    end
  end

  config.model Post do
    list do
      field :id
      field :title
      field :content
      field :user_id
      field :enabled, :toggle
    end

    edit do
      configure :user do
        visible false
      end
      field :title
      field :content, :ck_editor
      field :tags
      field :enabled, :toggle
    end

    create do
      field :title
      field :content, :ck_editor
      field :user_id, :hidden do
        default_value do
          bindings[:view]._current_user.id
        end
      end
      field :enabled, :toggle
    end
  end

  config.model User do
    edit do
      field :email
      field :password
      field :full_name
      field :phone_number
      field :role
      field :gender
      field :avatar
    end
  end

  config.model Relationship do
    visible false
  end

  config.model PostTag do
    visible false
  end

  config.model "Ckeditor::Asset" do
    visible false
  end

  config.model "Ckeditor::AttachmentFile" do
    visible false
  end

  config.model "Ckeditor::Picture" do
    visible false
  end

  config.parent_controller = "ApplicationController"
end
