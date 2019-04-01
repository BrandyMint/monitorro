class Admin::ExchangesController < Admin::ApplicationController
  def index
    render locals: {
      exchanges: exchanges,
      columns: [:name, :url, :xml_url, :is_available],
    }
  end

  private

  def exchanges
    Exchange.order(:id)
  end
end
