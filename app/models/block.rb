class Block < ActiveRecord::Base

  belongs_to :response
  has_many :children, class_name: Block, primary_key: :id, foreign_key: :parent_id
  has_one :parent, class_name: Block, primary_key: :parent_id, foreign_key: :id

  scope :root, -> { where(parent_id: nil) }

  def data
    JSON::parse(content["data"])
  end

end