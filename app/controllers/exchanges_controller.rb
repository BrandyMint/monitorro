class ExchangesController < ApplicationController
  def index
    render locals: {
      exchanges: Exchange.available
    }
  end

  def show
    exchange = Exchange.find(params[:id])
    render locals: {
      exchange: exchange,
      rates: RatesRepository.list_rates_for_exchange(exchange.id)
    }
  end
end
