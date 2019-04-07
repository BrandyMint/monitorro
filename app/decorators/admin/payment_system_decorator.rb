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
    buffer << h.link_to(h.ion_icon('checkmark'), h.allow_admin_payment_system_path(id), method: :put, class: 'btn btn-success btn-xs', title: 'Применить') unless object.allow?
    buffer << h.link_to(h.ion_icon('close'), h.ignore_admin_payment_system_path(id), method: :put, class: 'btn btn-danger btn-xs', title: 'Игнорировать') unless object.ignore?

    return if buffer.empty?
    h.content_tag :div, class: 'btn-group' do
      buffer.join.html_safe
    end
  end
end
