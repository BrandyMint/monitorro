class ExchangesController < ApplicationController
  def index
    render locals: {
      exchanges: Exchange.available
    }
  end
end
