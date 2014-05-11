module AwsConfig
  module_function

  def uploads_bucket
    @uplaods_bucket ||= "projets-uploads-#{Rails.env}"
  end

  def attachments_bucket
    @attachments_buckets ||= "projets-attachments-#{Rails.env}"
  end
end
