class UsersController < ApplicationController
  def new
    @title = 'Register'
    @user = User.new
  end

end
