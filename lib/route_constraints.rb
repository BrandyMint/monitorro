# frozen_string_literal: true

module RouteConstraints
  module UserConstraint
    def current_user(request)
      User.find_by_id(request.session[:user_id])
    end
  end

  class AdminRequiredConstraint
    include UserConstraint

    def matches?(request)
      user = current_user(request)
      user.present? && user.is_admin?
    end
  end
end
