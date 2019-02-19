class RatingQuestion
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :tag
  field :optionSelected
  
  validates :title, presence: true

end