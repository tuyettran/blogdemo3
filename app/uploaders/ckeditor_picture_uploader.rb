class CkeditorPictureUploader < CarrierWave::Uploader::Base
  include Ckeditor::Backend::CarrierWave
  include CarrierWave::MiniMagick
  storage :file

  def store_dir
    "uploads/ckeditor/pictures/#{model.id}"
  end

  process :read_dimensions

  version :thumb do
    process resize_to_fill: [Settings.ckeditor.thumb.size,
      Settings.ckeditor.thumb.size]
  end

  version :content do
    process resize_to_limit: [Settings.ckeditor.content.limit,
      Settings.ckeditor.content.limit]
  end

  def extension_white_list
    Ckeditor.image_file_types
  end
end
