class UserController < ApplicationController
  def profile
    unless current_user
      redirect_to root_path, notice: 'You are not signed in.'
    end
  end
end
