class Transaction < ActiveRecord::Base

  belongs_to :block
  belongs_to :query
  
  scope :success, -> { where(status: :success) }
  scope :error, -> { where(status: :error ) }
  
end
