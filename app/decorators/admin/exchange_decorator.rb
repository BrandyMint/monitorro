class Admin::ExchangeDecorator < ApplicationDecorator
  delegate_all

  def action
    buffer = []
    buffer << h.link_to(h.admin_exchange_path(id), method: :delete, class: 'btn btn-danger btn-xs', title: 'Кинуть в архив?', data: { confirm: 'Кидаем в корзину (можно будет восстановить)?' }) do
      h.ion_icon :close
    end if object.alive?

    return if buffer.empty?
    h.content_tag :div, class: 'btn-group' do
      buffer.join.html_safe
    end
  end
end
