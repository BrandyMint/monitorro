class ExchangesController < ApplicationController
  def index
    render locals: {
      exchanges: Exchange.available
    }
  end

  def show
    exchange = Exchange.find params[:id]
    render locals: {
      exchange: exchange,
      rates: RatesRepository.list_rates_for_exchange(exchange.id)
    }
  end

  def go
    exchange = Exchange.find params[:id]
    exchange.affiliate_events.create!
    if Rails.env.production?
      redirect_to exchange.affiliate_url.presence || exchange.url
    else
      flash.notice = "Как бы перешёл на #{exchange.name}"
      redirect_back fallback_location: root_url
    end
  end
end
