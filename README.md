Marshalize
==========

This Rails plugin provides serialization using Marshal in the same way Rails provides builtin serialization using YAML. In a model, just do
    class Robot < ActiveRecord::Base
      marshalize :features
    end
and your app will automagically handle the `features` attribute using Marshal, dumping when saving to the database, loading when fetching from it.

You can register any object.

Example
-------

    class Robot < ActiveRecord::Base
      
      marshalize :parameters               # the "parameters" attribute will be saved as binary data
      
      marshalize :features,  RobotFeature  # you can define what kind of object is to be marshalized
                                           # an error will be raised if another class is provided for
                                           # this attribute
      
      serialize  :status,    Array         # marshalization plays well with YAML classic serialization
    
    end

TODO
----

* super() stuff
* manage blobs, not just text field (buffer limitations)


License
-------

Released under the WTFPL (http://sam.zoy.org/wtfpl/COPYING)
