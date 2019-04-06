class Admin::PaymentSystemDecorator < ApplicationDecorator
  delegate_all

  def rates_count
    RatesRepository.get_rates_count(object.code) +
    RatesRepository.get_rates_count('*', object.code)
  end

  def code
    h.content_tag :div, style: 'max-width: 120px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;' do
      object.code
    end
  end

  def action
    buffer = []
    buffer << h.link_to('Применить', h.allow_admin_payment_system_path(id), method: :put, class: 'btn btn-success btn-xs') unless object.allow?
    buffer << h.link_to('Игнорировать', h.ignore_admin_payment_system_path(id), method: :put, class: 'btn btn-danger btn-xs') unless object.ignore?

    return if buffer.empty?
    h.content_tag :div, class: 'btn-group' do
      buffer.join.html_safe
    end
  end
end
