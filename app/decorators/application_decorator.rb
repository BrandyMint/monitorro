# frozen_string_literal: true

class ApplicationDecorator < Draper::Decorator
  delegate :current_user, :humanized_money_with_currency, to: :h

  def self.attribute_title(attr)
    a = attr.to_s.split('_')
    postfix = a.last
    if postfix.present? && I18n.available_locales.include?(postfix.to_sym)
      a.pop
      attr = a.join('_')
      locale_postfix = " (#{postfix})"
    end

    # TODO: взять в active_record если не хватает
    buffer = I18n.t attr,
                    scope: [:decorators, decorated_class_key],
                    default: decorated_class.human_attribute_name(attr)

    buffer << locale_postfix if locale_postfix.present?
    buffer
  end

  def self.decorated_class_key
    name.underscore.sub('_decorator', '')
  end

  def self.decorated_class
    name.sub('Decorator', '').sub('Admin::', '').constantize
  end

  private

  def t(key)
    I18n.t key
  end

  def time_formatted(time)
    return '-' unless time

    I18n.l time, format: :long
  end

  def flash_highlight(buffer)
    h.content_tag :div, buffer.html_safe, data: { effect: 'highlight' }
  end
end
