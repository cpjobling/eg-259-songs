class Song < ActiveRecord::Base
  attr_accessible :artist_or_group, :composer, :title
  validates :title, :artist_or_group, :presence => true
end
