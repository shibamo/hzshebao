class HomeController < ApplicationController
	before_action :authenticate
  def index
    @current_user = current_user
  end
end
