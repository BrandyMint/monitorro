# frozen_string_literal: true

module SessionsHelper
  # Отключать captcha если пользователь удачно залогинился больше этого количества раз подряд
  #
  SUCCESSFUL_LOGGED = Rails.env.development? ? 1 : 2

  # Использование подписанных куков в rack:
  # https://stackoverflow.com/questions/5343208/how-to-use-cookies-in-a-rack-middleware
  #
  def disable_captcha?
    success_login_count >= SUCCESSFUL_LOGGED
  end

  def success_login_count
    cookies.signed[:success_login_count].to_i
  end

  def clear_success_logged!
    cookies.signed[:success_login_count] = { value: 0, domain: Settings.cookie_domain }
  end

  def increment_success_logged!
    cookies.signed[:success_login_count] = { value: success_login_count + 1, domain: Settings.cookie_domain }
  end
end
