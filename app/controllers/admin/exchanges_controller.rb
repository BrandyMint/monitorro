class Admin::ExchangesController < Admin::ApplicationController
  layout 'admin/application-fluid'

  EDIT_COLUMNS = [:id, :is_available, :name, :url, :xml_url, :affiliate_url, :affiliate_login, :affiliate_password]

  def index
    render locals: {
      exchanges: exchanges,
      q: q,
      columns: EDIT_COLUMNS
    }
  end

  def new
    render locals: {
      exchange: Exchange.new
    }
  end

  def create
    exchange = Exchange.create! permitted_params

    redirect_to admin_exchanges_url(id: exchange.id, anchor: exchange.id), notice: "Добавили обменник #{exchange.name}"
  rescue ActiveRecord::RecordInvalid => e
    render :new, locals: {
      exchange: e.record,
    }
  end

  def update
    respond_to do |format|
      if exchange.update_attributes permitted_params
        format.html { redirect_to(admin_exchanges_path, notice: "#{exchange.name} обновлен") }
        format.json { respond_with_bip(exchange) }
      else
        format.html { render action: 'edit', locals: { exchange: exchange, columns: EDIT_COLUMNS } }
        format.json { respond_with_bip(exchange) }
      end
    end
  end

  private

  def exchange
    @exchange ||= Exchange.find params[:id]
  end

  def q
    @q ||= begin
             qq = Exchange.ransack(params[:q])
             qq.sorts = 'name desc' if qq.sorts.empty?
             qq
           end
  end

  def exchanges
    q.result
  end

  def permitted_params
    params[:exchange].permit!
  end
end
