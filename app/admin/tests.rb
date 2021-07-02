ActiveAdmin.register Test do
  menu label: 'Tests'
  config.sort_order = 'updated_at_desc'
  permit_params :name, :description, questions_attributes: [
    :id, :_destroy, :label, :content,
    options_attributes: %i[id _destroy content is_correct_answer]
  ]

  index do
    column :name do |test|
      # link_to test.name, resource_path(test)
      span test.name
    end

    column :description
    column '# Questions' do |test|
      span test.questions.size
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
    f.semantic_errors *f.object.errors.attribute_names

    f.inputs 'Test Details' do
      f.input :name, input_html: { placeholder: 'Give the Test a name here...' }
      f.input :description, input_html: { placeholder: 'Enter a description here...', rows: '3' }
    end

    f.inputs 'Questions' do
      f.has_many :questions, heading: false, allow_destroy: true do |q|
        q.input :label, input_html: { placeholder: 'Give the Question a label here...' }
        q.input :content, input_html: { placeholder: 'Enter a content here...', rows: '3' }
        q.has_many :options, heading: 'Options' do |o|
          o.input :content, input_html: { placeholder: 'Enter the option a content here...', rows: '3' }
          o.input :is_correct_answer, label: 'Correct answer'
        end
      end
    end

    f.actions
  end

  controller do
    def scoped_collection
      Test.includes(questions: :options)
    end
  end
end
