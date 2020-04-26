class V1::UsersController < ApplicationController
  skip_before_action :authenticate, only: :create

  # POST /users
  def create
    @user = User.create!
    render json: @user, status: :created
  end

  def index
    @users = User.all
    render json: @users, status: 200
  end

end
