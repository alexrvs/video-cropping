class V1::VideosController < ApplicationController
  before_action :set_video, only: [:show, :update, :destroy]

  # GET /videos
  def index
    @videos = current_user.videos.order_by(updated_at: :desc)
                  .page(oarams[:page] || 1).per(30)
    render json: @videos, each_serializer: VideoSerializer
  end

  # POST /videos
  def create
    if current_user.videos.create!(video_params)
      render json: {result: true}, status: :created
    else
      render json: {result: false}, status: :unprocessable_entity
    end

  end

  def reload

  end

  private

    # Only allow a trusted parameter "white list" through.
    def video_params
      params.require(:video).permit(:file, :start_time_trim, :end_time_trim)
    end
end
