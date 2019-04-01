# frozen_string_literal: true

class SessionsController < ApplicationController
  layout 'simple'

  # include SessionsHelper

  def new
    render locals: { user_session: UserSession.new, message: nil }
  end

  def create
    if user_session.valid?
      if login(user_session.login, user_session.password, true)
        # increment_success_logged!

        redirect_back_or_to '/', success: t('public.flashes.welcome', name: current_user.to_s)
      else

        # clear_success_logged!
        render :new, locals: { user_session: user_session, message: t('public.flashes.wrong_user') }
      end
    else

      # clear_success_logged!
      render :new, locals: { user_session: user_session, message: t('public.flashes.wrong_captcha') }
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: t('public.flashes.logout')
  end

  private

  def user_session
    @user_session ||= UserSession.new params[:user_session].permit(:login, :password, :remember_me)
  end
end
