class ApplicationController < ActionController::Base
  include PaginationConcern
  include RescueErrors

  helper NotyFlash::ApplicationHelper

  protect_from_forgery with: :exception

  skip_before_action :verify_authenticity_token, only: [:not_found]

  helper_method :from_ps, :to_ps
  helper_method :payment_systems
  helper_method :namespace

  private

  def namespace
    list = self.class.name.split('::')
    return :public if list.one?
    list.first.underscore.to_sym
  end

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
