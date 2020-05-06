class Api::V1::VideosController < ApplicationController

  def index
    @videos = current_user.videos.order_by(updated_at: :desc)
                  .page(params[:page] || 1).per(params[:per_page] || 30)
    render json: @videos, each_serializer: Api::V1::VideoSerializer
  end

  def create
    @video = current_user.videos.create!(video_params)
    CropperService.new(@video, :input_video).call
    @video.run_worker!
    render json: @video, serializer: Api::V1::VideoSerializer, status: :created
  end

  def reload
    @video = current_user.videos.where(id: params[:id]).first
    if @video.present?
      @video.restart!
      render json: @video, serializer: Api::V1::VideoSerializer
    else
      render status: :not_found
    end
  end

  private

  def video_params
    params.require(:video).permit(:input_video, :start_time_trim, :end_time_trim)
  end

end
