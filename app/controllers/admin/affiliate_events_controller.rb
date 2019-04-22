class Admin::AffiliateEventsController < Admin::ApplicationController
  def index
    redirect_to months_admin_affiliate_events_path
  end

  def months
    events, exchange_ids, columns = build_table AffiliateEvent, [:year, :month, :exchange_id]

    render :index, locals: {
      events:    events,
      exchanges: Exchange.where(id: exchange_ids),
      columns:    columns
    }
  end

  def days
    month = params[:month]
    events, exchange_ids, columns = build_table AffiliateEvent.by_month(month), [:year, :month, :day, :exchange_id]

    render :index, locals: {
      month:     month,
      events:    events,
      exchanges: Exchange.where(id: exchange_ids),
      columns:    columns
    }
  end

  private

  def build_table(scope, keys)
    table = { all: { all: 0 } }

    exchanges = Set.new
    columns = Set.new

    scope.group(*keys).count.each_pair do |key, count|
      row = table[key.last] ||= {}
      col = join_date_keys key
      columns << col
      exchanges << key.last

      row[col] = count
      row[:all] ||= 0
      row[:all] += count

      table[:all][col] ||= 0
      table[:all][col] += count
      table[:all][:all] += count
    end

    return table, exchanges, columns
  end

  def join_date_keys(key)
    key.slice(0, key.count-1).map { |k| '%02d' % k }.join('-')
  end
end
