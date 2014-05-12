class Query < ActiveRecord::Base

  has_one :response
  has_many :blocks, through: :response
  has_many :logs

  scope :get_status,  ->(name) { where(status: name) }
  scope :unprocessed, -> { get_status("new") }
  scope :processed,   -> { get_status("processed") }
  scope :processing,  -> { get_status("processing") }

end