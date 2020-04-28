class V1::UsersController < ApplicationController
  skip_before_action :authenticate, only: :create

  def create
    @user = User.create!
    render json: @user, serializer: UserSerializer,  status: :created
  end

  def index
    @users = User.all
    render json: @users, each_serializer: UserSerializer,  status: 200
  end

end
