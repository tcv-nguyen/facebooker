class Transaction < ActiveRecord::Base

  belongs_to :block
  
  scope :success, -> { where(status: :success) }
  scope :error, -> { where(status: :error ) }
  
end
