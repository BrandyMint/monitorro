module ApplicationHelper
  def humanized_hostname(url)
    return unless url.present?
    uri = Addressable::URI.parse url
    uri.host = SimpleIDN.to_unicode uri.host
    return uri.host if uri.path.blank? || uri.path=='/'
    uri.to_s
  end

  #def ion_icon(icon, css_class: nil, text: nil, title: nil)
    #buffer = content_tag :i, '', class: ['icon', 'ion-' + icon.to_s, css_class]
    #buffer << content_tag(:span, text, class: 'icon-text', title: title) if text.present?

    #buffer
  #end

  def app_title
    if controller.is_a? Admin::ApplicationController
      "MonitoRRo backoffice"
    else
      "MonitoRRo"
    end
  end

  def current_root_path
    namespace == :admin ? admin_root_path : root_path
  end

  def rate_growth(current, last)
    return content_tag :span, '&middot;'.html_safe, class: 'text-muted' if last.nil?
    return content_tag :span, '?', class: 'text-warning' if current.nil?
    if current > last
      content_tag :span, '&uarr;'.html_safe, class: 'text-success'
    elsif current < last
      content_tag :span, '&darr;'.html_safe, class: 'text-danger'
    else
      content_tag :span, '&middot;'.html_safe, class: 'text-muted'
    end
  end

  def humanized_time(time)
    return '-' unless time

    content_tag :span, title: time.to_s do
      l time, format: :short
    end
  end
end
