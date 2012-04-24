# EG-259 Songs

A simple application used as a demo in one of my courses. This file has
been translated from the [DokWiki original](http://eng-hope.swan.ac.uk/dokuwiki/eg-259:practicals:5). That version should be considered out of date!

## Live "Ruby on Rails" Demo 

These are the steps performed live in [Contact Hour 25] (http://eng-hope.swan.ac.uk/dokuwiki/eg-259:lecture20). I
have shown the steps based on a Windows installation. To install Rails
on Windows you are recommended to use
[RailsInstaller](http://railsinstaller.org/). 

The Macintosh comes with Ruby pre-installed and to install rails you
just need to follow these steps<sup><a href="#fn1" id="link_fn1">1)</a></sup>:

    sudo gem update --system
    sudo gem uninstall ruby-gems-update
    sudo gem install rails
    sudo gem install sqlite3 

In action, the Mac, being a Unix system, has a different command line
interface as you will have seen from the recording of the lecture.


###  1. Create the songs application 

    C:\Users\cpjobling>rails new song-o-matic


###  2. Start rails application and show default page 

    C:\Users\cpjobling>cd song-o-matic
    C:\Users\cpjobling\song-o-matic>rails server

Open [http://localhost:3000/](http://localhost:3000/) in browser.


###  3. Configure database 
 
  * Rails (since version 2.0.2) comes preconfigured to use a lightweight, open-source SQL database 
called [SQLite3](http://www.sqlite.org/)<sup><a href="#fn2" id="link_fn2">2</a>)</sup>. The configuration file is
`..\song-o-matic\config\database.yml`:

``` yaml
# SQLite version 3.x
#   gem install sqlite3
development:
  adapter: sqlite3
  database: db/development.sqlite3
  pool: 5
  timeout: 5000

# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.
test:
  adapter: sqlite3
  database: db/test.sqlite3
  pool: 5
  timeout: 5000

production:
  adapter: sqlite3
  database: db/production.sqlite3
  pool: 5
  timeout: 5000
```

To run rails with these defaults, you need do no more to configure your databases.

It's a good idea to stick with SQLite3 for development and testing, but
for deployment you may need a more capable database engine. Luckily, you
can also configure Rails to use MySQL in deployment, in which case you'd
edit the last entry of the configuration file to read: 
``` yaml
deployment:
  adapter: mysql
  encoding: utf8
  database: songs_production
  username: root
  password:
  host: localhost
```
You would then need to use *phpMyAdmin* or the *mysql* command to
create the database *songs_production* and set up suitable user
permissions<sup><a href="#fn3" id="link_fn3">3)</a></sup>.




###  4. Create a songs model and a songs controller 


Stop (`Ctrl- c`) the web application then create a model to
represent the the songs table and its associated controller and
views.

````
C:\Users\cpjobling\song-o-matic>rails generate scaffold song title:string composer:string artist_or_group:string
````
Examine the generated files for the model
`..\song-o-matic\app\models\song.rb`:
``` ruby
class Song < ActiveRecord::Base
end
```
Note that most of the default behaviour for the model is abstracted into
the superclass `ActiveRecord::Base`. We only need to define
specialisms, most of the behaviour is inherited. This is another example
of *DRY* and *Convention over Configuration*. 

The (page) controller `..\song-o-matic\app\models\song.rb` is a little
more complex:
``` ruby
class SongsController < ApplicationController
  # GET /songs
  # GET /songs.xml
  def index
    @songs = Song.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @songs }
    end
  end

  # GET /songs/1
  # GET /songs/1.xml
  def show
    @song = Song.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @song }
    end
  end

  # GET /songs/new
  # GET /songs/new.xml
  def new
    @song = Song.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @song }
    end
  end

  # GET /songs/1/edit
  def edit
    @song = Song.find(params[:id])
  end

  # POST /songs
  # POST /songs.xml
  def create
    @song = Song.new(params[:song])

    respond_to do |format|
      if @song.save
        format.html { redirect_to(@song, :notice => 'Song was
successfully created.') }
        format.xml  { render :xml => @song, :status => :created,
:location => @song }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @song.errors, :status =>
:unprocessable_entity }
      end
    end
  end

  # PUT /songs/1
  # PUT /songs/1.xml
  def update
    @song = Song.find(params[:id])

    respond_to do |format|
      if @song.update_attributes(params[:song])
        format.html { redirect_to(@song, :notice => 'Song was
successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @song.errors, :status =>
:unprocessable_entity }
      end
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.xml
  def destroy
    @song = Song.find(params[:id])
    @song.destroy

    respond_to do |format|
      format.html { redirect_to(songs_url) }
      format.xml  { head :ok }
    end
  end
end
```
The apparent complexity is because methods have been provided to support
the so-called *RESTful interface* that Rails provides. It is another
example of *convention over configuration*. In fact when you look at
the code, there are 7 methods which the controller implements:
  - show the list of songs (*index*)
  - display an individual song (*show*)
  - create a new song (*new*) ...
  - and add it to the database (*create*)
  - change an existing song (*edit*) and ...
  - store the changed song in the database (*update*), and
  - delete a song from the database (*destroy*).
  
Note the use of the HTML verbs `GET`, `PUT`, `POST`, and `DELETE` in each of these
cases, the URLs that are associated with each action, and also note that
both HTML (the default) and JSON are supported resource
types<sup><a href="#fn4" id="link_fn4">4)</a></sup>.

The *scaffolding* command that was added to the ''rails generate''
instruction has also created suitable HTML code to allow the data to be
displayed in the web application. The views (examples of the *Template
View* pattern) are stored in ''..\song-o-matic\app\views\songs'' and
there is a view for each of the browser actions *edit*, *index*,
*new* and *show*. 

For example the *new* view is:
``` html
<h1>New song</h1>

<%= render 'form' %>

<%= link_to 'Back', songs_path %>
```
and the form is
``` html
<%= form_for(@song) do |f| %>
  <% if @song.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(@song.errors.count, "error") %> prohibited this
song from being saved:</h2>

      <ul>
      <% @song.errors.full_messages.each do |msg| %>
        <li><%= msg %></li>
      <% end %>
      </ul>
    </div>
  <% end %>

  <div class="field">
    <%= f.label :title %><br />
    <%= f.text_field :title %>
  </div>
  <div class="field">
    <%= f.label :composer %><br />
    <%= f.text_field :composer %>
  </div>
  <div class="field">
    <%= f.label :artist_or_group %><br />
    <%= f.text_field :artist_or_group %>
  </div>
  <div class="actions">
    <%= f.submit %>
  </div>
<% end %>

```

Finally, the `rails generate` command created a database *migration*
file:
``` ruby
class CreateSongs < ActiveRecord::Migration
  def self.up
    create_table :songs do |t|
      t.string :title
      t.string :composer
      t.string :artist_or_group

      t.timestamps
    end
  end

  def self.down
    drop_table :songs
  end
end
```
which uses ruby to provide a database agnostic way of creating and
updating the database. We use the migration to create the database by
running
```
C:\Users\cpjobling\song-o-matic>rake db:migrate
```

The file naming convention, e.g.  `20110508123454_create_songs.rb`,
includes a time-stamp to ensure that migrations are applied in the
correct order.

### 5. Use a seed file to populate the database with some initial data

The `rails new` command also creates a ruby file
`..\song-o-matic\db\seeds.rb` that can be used to populate the
database with some initial data:
````
C:\Users\cpjobling> rake db:seed
````
We edit this file to add some data. In Rails, we can create a new data
record using:
``` ruby
Song.create(:title => "Wish You Where Here", 
  :composer => "Roger Waters and David Gilmour", 
  :artist_or_group => "Pink Floyd")
```
This makes use of the *Song* constructor<sup><a href="#fn5" id="fn5_link">5)</a></sup>
as a generator for a new record. After
editing, the complete migration is:
``` ruby
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
            :artist_or_group => "David Bowie and the Spiders from
Mars"},
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
```

Note, if you look at the code in the ''songs_controller'' you'll see
that the ''create'' action is used like this:
``` ruby
@song = Song.new(params[:song])
```
This takes the ''parameter'' variable((A *hash* or *dictionary*))
from the web browser (equivalent to ''$_POST'' in PHP) to populate the
data record.

###  6. Demonstrate the CRUD behaviour 

Restart the application web server:
<cli prompt=">">
C:\Users\cpjobling\song-o-matic>rails server
</cli>

Open a web browser and browse to http://localhost:3000/songs/

Create a new song, list songs, update songs, delete a song: i.e.
demonstrate Create Retrieve Update Delete (CRUD) interface that is
typical for many web-fronted database applications. Observe the URIs for
each case.

Note that all the behaviour (mapping URIs to model methods and
parameters) is inherited from ''ActionController'' and all the
presentation (HTML views) were created by the ''scaffolding'' option
used when the model was created.
###  7. Validate the form data 

Add validation to a field of the model:
``` ruby
class Song < ActiveRecord::Base
  validates :title, :artist_or_group, :presence => true
end 
```
Create a new song or edit an existing one to show that the validator
works.

###  8. Examine "scaffold" code 

In addition to creating the controller and the migration file, the
command
<cli prompt=">">
C:\Users\cpjobling\song-o-matic>rails generate scaffold song
title:string composer:string artist_or_group:string
</cli>
creates a view for each default action in controller (i.e. *index*,
*new*, *edit*, *show*). Examine and edit a view template (located
in ''..\song-o-matic\app\views\songs\''). This is
''..\song-o-matic\app\views\songs\index.html.erb'':
``` html
<h1>Listing songs</h1>

<table>
  <tr>
    <th>Title</th>
    <th>Composer</th>
    <th>Artist or group</th>
    <th></th>
    <th></th>
    <th></th>
  </tr>

<% @songs.each do |song| %>
  <tr>
    <td><%= song.title %></td>
    <td><%= song.composer %></td>
    <td><%= song.artist_or_group %></td>
    <td><%= link_to 'Show', song %></td>
    <td><%= link_to 'Edit', edit_song_path(song) %></td>
    <td><%= link_to 'Destroy', song, :confirm => 'Are you sure?',
:method => :delete %></td>
  </tr>
<% end %>
</table>

<br />

<%= link_to 'New Song', new_song_path %>
```

The things to note about this is that the code is HTML with ruby
embedded between template marker tags ''<% .. %>''. The code is
relatively easy to understand. Also note that this template can be
embedded at run time into a template defined in
''..\song-o-matic\app\views\layouts''. This is where you would create a
wrapper file that was valid HTML and loads the required stylesheets.
 
## Footnotes

<a id="fn1" href="#link_fn1">1)</a> Adapted from Sam Ruby, Dave Thomas and David Heinermeier Hansson, *Agile Web Development with Rails*, 4th
Edition, 2011.

<a id="fn2" href="#link_fn2">2)</a> I discovered last year that PHP 5 includes SQLite3 too.

<a id="fn3" href="#link_fn3">3)</a> The example assumes MySQL in its default state with no root password, which of course you should never use in a live deployment!

<a id="fn4" href="#link_fn4">4)</a> XML can also be used.

<a id="fn5" href="#link_fn5">5)</a> Actually the *ActiveRecord* constructor.