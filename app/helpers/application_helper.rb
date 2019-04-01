module ApplicationHelper
  def app_title
    "MinotoRRo #{AppVersion}"
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
