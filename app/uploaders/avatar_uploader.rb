class AvatarUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
