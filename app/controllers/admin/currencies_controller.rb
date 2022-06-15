class Admin::CurrenciesController < Admin::ApplicationController
  def index
    render locals: {
      currencies: Money::Currency.all,
    }
  end
end
