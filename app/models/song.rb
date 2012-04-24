class Song < ActiveRecord::Base
  attr_accessible :artist_or_group, :composer, :title
end
