class BestChangeService
  ROUND = 4
  include Virtus.model strict: true
  include AutoLogger
  include Mathematic

  attribute :exchange_rate, ExchangeRate

  def rows
    @rows ||= build[:rows]
  end

  def status
    @status ||= build[:status]
  end

  def my_row
    @my_row ||= build[:my_row]
  end

  private

  delegate :bestchange_key, :currency_pair, to: :exchange_rate

  def build
    my_row = nil

    list = source_rows.map do |row|
      base_rate_percent = calculate_comission(row.rate, base_rate_multiplicator).round ROUND
      bcr = BestChangeRecord.new(
        exchanger_id:      row.exchanger_id,
        exchanger_name:    row.exchanger_name,
        buy_price:         row.buy_price,
        sell_price:        row.sell_price,
        reserve:           row.reserve,
        time:              row.time,
        position:          row.position,
        base_rate_percent: base_rate_percent,
        target_rate_percent: row.is_my? ? exchange_rate.comission : base_rate_percent
      )

      if row.is_my? # row.exchanger_id == Settings.best_change_repository.exchanger_id
        my_row = bcr
      end

      # logger.info "#{row.exchanger_name}: #{row.rate} base_rate_percent=#{bcr.base_rate_percent} target_rate_percent=#{bcr.target_rate_percent}"

      bcr
    end

    sorted_list = list.sort

    if my_row.present?
      my_row.status = build_status(
        row: my_row,
        target_position: sorted_list.index { |r| r == my_row }
      )
    end

    { rows: sorted_list, my_row: my_row, status: my_row.try(:status) }
  end

  def build_status(row:, target_position:)
    bcs = BestChangeStatus.new(
      id:                           "#{exchange_rate.id}-#{row.id}",
      position:                     row.position,
      target_position:              target_position,
      target_type:                  :rate,
      target_base_percent_rate:     exchange_rate.comission,
      bestchange_base_percent_rate: row.base_rate_percent,
      finite_rate:                  Rate.new(in_amount: row.buy_price, out_amount: row.sell_price)
    )
    bcs.state = bcs.bestchange_base_percent_rate.round(ROUND) == bcs.target_base_percent_rate.round(ROUND) ? BestChangeStatus::STATE_ACTUAL : BestChangeStatus::STATE_AWAIT
    bcs
  end

  def source_rows
    @source_rows ||= BestChangeRepository.getRows(bestchange_key)
  end

  def base_rate_multiplicator
    @base_rate_multiplicator ||= Universe.currency_rates_repository.find_currency_rate_by_pair(currency_pair).rate_value
  end
end
