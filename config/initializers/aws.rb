module AwsConfig
  module_function

  def uploads_bucket
    @uplaods_bucket ||= "projets-uploads-#{Rails.env}"
  end

  def attachments_bucket
    @attachments_buckets ||= "projets-attachments-#{Rails.env}"
  end

  def access_key_id
    ENV.fetch("AWS_ACCESS_KEY_ID")
  end

  def secret_access_key
    ENV.fetch("AWS_SECRET_ACCESS_KEY")
  end
end

AWS.config(access_key_id: AwsConfig.access_key_id,
           secret_access_key: AwsConfig.secret_access_key)
