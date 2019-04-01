class ApplicationController < ActionController::Base
  helper NotyFlash::ApplicationHelper

  helper_method :from_ps, :to_ps
  helper_method :payment_systems

  private

  def payment_systems
    @payment_systems ||= PaymentSystem.order(:name)
  end

  def from_ps
    @from_ps ||= params[:from] ? PaymentSystem.find_by_code(params[:from]) : PaymentSystem.take
  end

  def to_ps
    @to_ps ||= params[:to] ? PaymentSystem.find_by_code(params[:to]) : PaymentSystem.take
  end
end
