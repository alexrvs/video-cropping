class V1::UsersController < ApplicationController
  skip_before_action :authenticate, only: :create

  def create
    @user = User.create!
    render json: @user, serializer: V1::UserSerializer,  status: :created
  end

  def index
    @users = User.all
    render json: @users, each_serializer: V1::UserSerializer,  status: 200
  end

end
