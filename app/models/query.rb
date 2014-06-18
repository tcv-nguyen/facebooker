class Query < ActiveRecord::Base

  has_one :response
  has_many :blocks, -> { where(parent_id: nil) }, through: :response
  has_many :logs
  has_many :transactions

  scope :get_status,  ->(name) { where(status: name) }
  scope :unprocessed, -> { get_status("new") }
  scope :processed,   -> { get_status("processed") }
  scope :processing,  -> { get_status("processing") }

  def success?
    !error?
  end

  def error?
    logs.error.any?
  end

end