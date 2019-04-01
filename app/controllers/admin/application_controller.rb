class Admin::ApplicationController < ApplicationController
  before_action :require_login_from_http_basic
end
