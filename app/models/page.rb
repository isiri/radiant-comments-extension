class Page < ActiveRecord::Base
  has_many :comments
end