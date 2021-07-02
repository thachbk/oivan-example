ActiveAdmin.register User do
  menu label: 'Users'
  config.sort_order = 'name_asc'
  permit_params :name, :email, :password, :password_confirmation, :role_ids

  index do
    column :name do |user|
      link_to user.name, resource_path(user)
    end

    column :email
    column :role do |user|
      span user.roles&.first&.name
    end

    # now define the links...
    column :Actions do |resource|
      links = ''.html_safe
      # if controller.action_methods.include?('show') and controller.current_ability.can?(:read, resource)
      #   links += link_to I18n.t('active_admin.view'), resource_path(resource), :class => "member_link view_link"
      # end
      if controller.action_methods.include?('edit') and controller.current_ability.can?(:edit, resource)
        links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link"
      end
      if controller.action_methods.include?('destroy') and controller.current_ability.can?(:destroy, resource)
        links += link_to I18n.t('active_admin.delete'), resource_path(resource), :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'), :class => "member_link delete_link"
      end
      links
    end
  end

  form do |f|
    f.inputs 'Users Details' do
      f.input :name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :role_ids,
        as: :select,
        collection: Role.all.collect { |r| [r.name, r.id] },
        input_html: { placeholder: 'Select role' }
    end

    f.actions
  end

  show do
    attributes_table do
      row :name
      row :email
      row 'Password' do | user| 
        span '********'
      end
      row 'Role' do |user|
        span user.roles&.first&.name
      end
    end
  end

  controller do
    def scoped_collection
      User.includes(:roles)
    end

    def update
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete :password
        params[:user].delete :password_confirmation
      end

      super
    end
  end
end
