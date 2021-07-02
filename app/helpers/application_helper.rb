module ApplicationHelper
  def bootstrap_class_for(flash_type)
    case flash_type
    when 'success'
      'alert-success'
    when 'error'
      'alert-danger'
    when 'alert'
      'alert-warning'
    when 'notice'
      'alert-info'
    else
      flash_type.to_s
    end
  end

  def simple_format_html(text)
    simple_format text.to_s.squish, {}, sanitize: false, wrapper_tag: 'div'
  end

  def page_flash
    content_tag(:div, id: "flash-container") do
      if !flash[:error].blank?
        content_tag(:div, content_tag(:button, "×", class: 'close', :data => {dismiss: 'alert'})+content_tag(:p, flash[:error]), class: "alert alert-danger alert-dismissable fade in")
      elsif !flash[:warning].blank?
        content_tag(:div, content_tag(:button, "×", class: 'close', :data => {dismiss: 'alert'})+content_tag(:p, flash[:warning]), class: "alert alert-warn alert-dismissable fade in")
      elsif !alert.blank?
        content_tag(:div, content_tag(:button, "×", class: 'close', :data => {dismiss: 'alert'})+content_tag(:p, alert), class: "alert alert-danger alert-dismissable fade in")
      elsif !notice.blank?
        content_tag(:div, content_tag(:button, "×", class: 'close', :data => {dismiss: 'alert'})+content_tag(:p, notice), class: "alert alert-success alert-dismissable fade in")
      else
        ""
      end
    end unless alert.blank? && notice.blank? && flash[:error].blank? && flash[:warning].blank?
  end

  def error_messages!(resource)
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg, class: 'error') }.join
    sentence = I18n.t("errors.messages.not_saved",
                      count: resource.errors.count,
                      resource: resource.class.model_name.human.downcase)

    html = <<-HTML
    <div id="error_explanation">
      <h2>#{sentence}</h2>
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end
end
