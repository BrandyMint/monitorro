class Admin::ApplicationController < ApplicationController
  layout 'admin/application'
  before_action :require_login
end
