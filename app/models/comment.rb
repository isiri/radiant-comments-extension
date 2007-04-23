class Comment < ActiveRecord::Base
  belongs_to :page
  
  validates_presence_of :content
end