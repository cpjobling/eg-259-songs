# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
Song.create(:title => "Wish You Where Here",
  :composer => "Roger Waters and David Gilmour",
  :artist_or_group => "Pink Floyd")

beatles = "The Beatles"
landm = "John Lennon and Paul McCartney"
songs = Song.create(
          [
            {:title => "Please, Please Me",
            :composer => landm,
            :artist_or_group => beatles},
            { :title => "Space Oddity",
            :composer => "David Bowie",
            :artist_or_group => "David Bowie and the Spiders from Mars"},
            {:title => "Don't Sleep in the Subway Darling",
            :composer => "Jackie Trent and Tony Hatch",
            :artist_or_group => "Petula Clark"},
            {:title => "Wish You Where Here",
            :composer => "Roger Waters and David Gilmour",
            :artist_or_group => "Pink Floyd"},
            {:title => "It's a Kind of Magic",
            :composer => "Freddy Mercury",
          :artist_or_group => "Queen"}
          ]
        )

