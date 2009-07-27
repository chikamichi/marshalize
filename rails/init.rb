require 'marshalize'

ActiveRecord::Base.send :include, Marshalization::Base
ActiveRecord::Base.send :include, Marshalization::AttributeMethods
ActiveRecord::Base.send :include, Marshalization::Dirty
