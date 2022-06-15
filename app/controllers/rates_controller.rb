class RatesController < ApplicationController
  def index
    render locals: { rates: RatesRepository.list_rates(from_ps, to_ps) }
  end
end
