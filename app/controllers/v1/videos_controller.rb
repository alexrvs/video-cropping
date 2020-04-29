class V1::VideosController < ApplicationController

  def index
    @videos = current_user.videos.order_by(updated_at: :desc)
                  .page(oarams[:page] || 1).per(30)
    render json: @videos, each_serializer: V1::VideoSerializer
  end

  def create
    @video = current_user.videos.create!(video_params)
    @video.run_worker!
    render json: @video, serializer: V1::VideoSerializer, status: :created
  end

  def reload
    @video = current_user.videos.where(id: params[:id]).first
    @video.restart!
    render json: @video, serializer: V1::VideoSerializer
  end

  private

    def video_params
      params.require(:video).permit(:input_video, :start_time_trim, :end_time_trim)
    end

end
