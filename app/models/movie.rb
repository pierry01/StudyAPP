class Movie < ApplicationRecord
  has_one_attached :image
  has_one_attached :clip
  
  paginates_per 6
end
