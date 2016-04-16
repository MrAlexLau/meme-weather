class HomeController < ApplicationController
  def index
    @settings = Setting.new(session[:settings])
  end
end
