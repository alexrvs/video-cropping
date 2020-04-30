# encoding: utf-8

class VideoTrimUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  include ::CarrierWave::Backgrounder::Delay
  include ::CarrierWave::Video

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  process :encode

  def trimmer
    binding.pry
    video = FFMPEG::Movie.new(model.input_video.path)
    video.transcode("#{::Rails.root}/uploads/#{mounted_as}/#{model.id}/test.mp4",
                    [
                       "-ss", model.start_time_trim.to_s,
                       "-t", (model.end_time_trim - model.start_time_trim).to_s
                   ])
  end

  def encode
    movie = ::FFMPEG::Movie.new(current_path)
    tmp_path = File.join( File.dirname(current_path),   "tmpfile.mp4" )
    options = [
        "-ss", model.start_time_trim.to_s,
        "-t", (model.end_time_trim - model.start_time_trim).to_s
    ]
    movie.transcode(tmp_path, options)
    File.rename tmp_path, current_path
  end

  # Process files as they are uploaded:
  #process :scale => [200, 300]

  #
  # def scale(width, height)
  #   # do something
  # end
  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(avi mov mp4 flv wmv 3gp webm m4v)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
