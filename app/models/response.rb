class Response < ActiveRecord::Base

  belongs_to :query
  has_many :blocks

  scope :get_status,  ->(name) { where(status: name) }
  scope :failed, -> { get_status("fail") }
  scope :success, -> { get_status("done") }

end