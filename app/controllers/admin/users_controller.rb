class Admin::UsersController < Admin::ApplicationController
  def index
    render locals: {
      users: User.order(:id)
    }
  end
end
