RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, "User", "PaperTrail::Version" # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

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
  end

  config.model Post do
    edit do
      configure :user do
        visible false
      end
      field :title
      field :content, :ck_editor
      field :tags
    end

    create do
      field :title
      field :content, :ck_editor
      field :user_id, :hidden do
        default_value do
          bindings[:view]._current_user.id
        end
      end
    end
  end

  config.model User do
    create do
      field :email do
        default_value ""
      end
      field :password
      field :full_name
      field :phone_number
      field :role
      field :gender
      field :avatar
    end

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
