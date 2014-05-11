class Attachment < ActiveRecord::Base
  belongs_to        :attachable,        polymorphic: true
  belongs_to        :user
  belongs_to        :upload

  has_many          :comments,          as: :commentable

  validates         :original_filename, presence: true
  validates         :size,              presence: true
  validates         :content_type,      presence: true
  validates         :key,               presence: true
  validates         :attachable,        presence: true
  validates         :user,              presence: true
  validates         :upload,            presence: true

  validate          :upload_must_be_finished

  before_validation :copy_from_upload,  on: :create
  before_create     :move_upload_to_attachments_bucket

  def generate_url
    attachments_bucket.objects[key].url_for(:get, expires: 1.week.from_now).to_s
  end

  private

  def move_upload_to_attachments_bucket
    uploads_bucket.objects[upload.key].move_to(key,  bucket: attachments_bucket)
  rescue AWS::Errors::Base
    errors.add(:upload, "Could not copy uploaded file")
  end

  def copy_from_upload
    if upload.present?
      self.key ||= "#{upload.key}-#{Time.now.to_i}-#{Time.now.usec}"
    end
  end

  def upload_must_be_finished
    if upload.present?
      errors.add(:upload, "Upload was not finished") unless upload.finished?
    end
  end

  def uploads_bucket
    @uploads_bucket ||= storage.buckets[AwsConfig.uploads_bucket]
  end

  def attachments_bucket
    @attachments_bucket ||= storage.buckets[AwsConfig.attachments_bucket]
  end

  def storage
    @storage ||= AWS::S3.new
  end
end
