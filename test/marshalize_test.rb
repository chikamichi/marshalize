#require File.dirname(__FILE__) + '/test_helper.rb'

class ExtendActiveRecordTest < Test::Unit::TestCase

  require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
  ActiveRecord::Base.establish_connection(config[db_adapter])
  load(File.dirname(__FILE__) + "/schema.rb")

  class Bird < ActiveRecord::Base
    marshalize :songs
    marshalize :locations, Array
    serialize  :friends, Hash
  end

  def test_marshalize_the_songs_attribute

    #load_schema
    

    test_songs = {'Il fait beau' => 'texte de la chanson...', 'Perche sur une branche' => 'piou piou piou!'}

    piou = Bird.new


    piou.name      = "Coco"
    piou.songs     = test_songs
    
    
    piou.save!


    retrieved = Bird.find_by_id piou.id

    
    assert_equal test_songs, retrieved.songs

    #piou.locations_will_change!
    piou.name = "Bibi"
    piou.songs = 23
    test_locations = ["Milan", "Paris"]
    piou.locations = test_locations
    test_friends = {"toucan" => 2, "lark sparrow" => 10}
    piou.friends = test_friends
    piou.save!

    retrieved = Bird.find_by_id piou.id

    assert_equal "Bibi", retrieved.name

    assert_kind_of(Array, retrieved.locations, "Locations are stored in an array.")
    assert_equal test_locations, retrieved.locations

    assert_kind_of(Hash, retrieved.friends, "Friends are stored in a hash.")
    assert_equal test_friends, retrieved.friends

  end
end
