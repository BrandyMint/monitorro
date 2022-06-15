class Admin::PaymentSystemsController < Admin::ApplicationController
  def index
  end

  def update
    respond_to do |format|
      if payment_system.update_attributes permitted_params
        format.html { redirect_to(admin_payment_systems_path, notice: "#{payment_system.name} обновлен") }
        format.json { respond_with_bip(payment_system) }
      else
        format.html { render action: 'edit', locals: { payment_system: payment_system } }
        format.json { respond_with_bip(payment_system) }
      end
    end
  end

  def ignore
    payment_system.ignore!
    redirect_to admin_payment_systems_path, notice: "Игнорируем #{payment_system}"
  end

  def allow
    payment_system.allow!
    redirect_to admin_payment_systems_path, notice: "Используем #{payment_system}"
  end

  private

  def payment_system
    @payment_system ||= PaymentSystem.find params[:id]
  end

  def permitted_params
    params[:payment_system].permit!
  end
end
