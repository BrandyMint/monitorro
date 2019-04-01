module ApplicationHelper
  def allow_edit_column?(record, column)
    return false if column.to_s == 'id'

    # Бывает в декораторе есть метод, а в самой модели нет
    return false unless record.respond_to? column
    return false unless record.respond_to? column.to_s + '='

    value = record.send column
    return false if value.is_a? ActiveRecord::Associations::CollectionProxy

    return record.respond_to?(:parent) && record.parent.updatable_by?(current_user) unless record.respond_to? :udpatable_by?
    return false unless record.updatable_by? current_user

    true
  end

  def app_title
    if controller.is_a? Admin::ApplicationController
      "Админка #{AppVersion}"
    else
      "MinotoRRo #{AppVersion}"
    end
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
