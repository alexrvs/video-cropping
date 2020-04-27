# encoding: utf-8

class VideoUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  include ::CarrierWave::Backgrounder::Delay
  include ::CarrierWave::Video

  PROCESSED_DEFAULTS = {
      resolution: '500x400', # desired video resolution; by default it preserves height ratio preserve_aspect_ratio: :height.
      video_codec: 'libx264', # H.264/MPEG-4 AVC video codec
      constant_rate_factor: '30', # GOP Size
      frame_rate: '25', # frame rate
      audio_codec: 'aac', # AAC audio codec
      audio_bitrate: '64k', # Audio bitrate
      audio_sample_rate: '44100' # Audio sampling frequency
  }.freeze

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end
  #process encode: [:mp4, PROCESSED_DEFAULTS]

  # Process files as they are uploaded:
  # process :scale => [200, 300]
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
