class UsersController < ApplicationController
  def new
    @title = 'Register'
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = 'Registration successful. Welcome to photoNatic.'
      redirect_to root_path
    else
      @title = 'Register'
      @user.password = ""
      @user.password_confirmation = ""
      render :new
    end
  end

end
