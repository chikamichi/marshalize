require 'activesupport'

# This module is split in several submodules for selective inclusion purpose
module Marshalization #:nodoc:

  VERSION = 0.1

  module Dirty #:nodoc:

    private

    def update_with_marshalization
      if partial_updates?
        # Serialized and marshalized attributes should always be written in case they've been
        # changed in place.
        update_without_dirty(self.class.marshalized_attributes.keys)
      else
        update_without_dirty
      end

      update_with_dirty # an implicit call to super, which would fail as it is a private method
                        # update_with_dirty is not
    end

    def self.included(receiver)
      receiver.alias_method_chain :update, :marshalization
    end
  end
  
  #module Timestamp #:nodoc:
    
    #private

    #def update_with_timestamps(*args) #:nodoc:
      #if record_timestamps && (!partial_updates? || changed?)
        #t = self.class.default_timezone == :utc ? Time.now.utc : Time.now
        #write_attribute('updated_at', t) if respond_to?(:updated_at)
        #write_attribute('updated_on', t) if respond_to?(:updated_on)
      #end
      #update_without_timestamps()
    #end
  #end

  module Base # :nodoc:

    marshalized_attributes ||= Hash.new

    module ClassMethods #:nodoc:

      # If you have an attribute that needs to be saved to the database as an object, and retrieved as the same object,
      # then specify the name of that attribute using this method and it will be handled automatically.
      # The serialization is done through Marshal. If +class_name+ is specified, the serialized object must be of that
      # class on retrieval or SerializationTypeMismatch will be raised.
      #
      # ==== Parameters
      #
      # * +attr_name+ - The field name that should be serialized.
      # * +class_name+ - Optional, class name that the object type should be equal to.
      #
      # ==== Example
      #   # Serialize a preferences attribute
      #   class User
      #     serialize :preferences
      #   end
      def marshalize(attr_name, class_name = Object)
        attr_name = attr_name.to_s
        marshalized_attributes[attr_name] = class_name
      end

      # Returns a hash of all the attributes that have been specified for serialization as keys and their class restriction as values.
      def marshalized_attributes
        read_inheritable_attribute(:attr_marshalized) or write_inheritable_attribute(:attr_marshalized, {})
      end

    end # class: Marshalization::Base::ClassMethods

    module InstanceMethods #:nodoc:

      # Encode an attribute with ActiveSupport::Base64.encode64
      def encode_attribute(attribute)
        ActiveSupport::Base64.encode64(attribute)
      end

      # Decode an attribute with ActiveSupport::Base64.decode64
      def decode_attribute(attribute)
        ActiveSupport::Base64.decode64(attribute)
      end

      # Returns a copy of the attributes hash where all the values have been safely quoted for use in
      # an SQL statement.
      def attributes_with_quotes_with_marshalization(include_primary_key = true, include_readonly_attributes = true, attribute_names = @attributes.keys)

        quoted = {}
        connection = self.class.connection
        attribute_names.each do |name|
          if (column = column_for_attribute(name)) && (include_primary_key || !column.primary)

            if self.class.marshalized_attributes.has_key?(name)
              # smart-quoting Marshal-dumped values
              quoted[name] = "'#{@attributes[name].to_s}'"
            else
              value = read_attribute(name)

              # We need explicit to_yaml because quote() does not properly convert Time/Date fields to YAML.
              if value && self.class.serialized_attributes.has_key?(name) && (value.acts_like?(:date) || value.acts_like?(:time))
                value = value.to_yaml
              end

              quoted[name] = connection.quote(value, column)
            end
          end
        end
        include_readonly_attributes ? quoted : remove_readonly_attributes(quoted)
      
        # TODO in order to get rid of the aliasing, handle marshalized attributes, then call super
        # passing all attributes but marshalized's. In fact, do it the reverse order so that the
        # quoted hash is not made empty in super after we filled it
        
        #attribute_names.delete_if { |attribute| self.class.marshalized_attributes.has_key?(attribute) }
        ##do stuff with marshalized_attributes.each -> quoted[name]
        #puts "~~~~~~"
        #puts attribute_names
        #super(true, true, attribute_names)

      end
    end # module: Marshalization::Base::InstanceMethods

    def self.included(receiver)
      receiver.send :include, InstanceMethods
      receiver.send :extend,  ClassMethods

      unless receiver.respond_to?(:attributes_with_quotes_without_marshalization)
        receiver.instance_eval do
          alias_method_chain :attributes_with_quotes, :marshalization
        end
      end

      #unless receiver.respond_to?(:update_with_dirty_without_marshalization)
        #receiver.instance_eval do
          #alias_method_chain :update_with_dirty, :marshalization
        #end
      #end
    end

  end # module: Marshalization::Base

  module AttributeMethods

    module ClassMethods

      # This refactoring may break with incoming Rails releases since there is no call to super.
      # See below for some explanations -- IMO it's too much work for a plugin, so this method
      # is kind of a bold patch in itself
      def define_attribute_methods
        return if generated_methods?
        columns_hash.each do |name, column|
          if instance_method_already_implemented?(name)
          else
            if self.serialized_attributes[name]
              define_read_method_for_serialized_attribute(name)
            elsif self.marshalized_attributes[name]
              define_read_method_for_marshalized_attribute(name)
            elsif create_time_zone_conversion_attribute?(name, column)
              define_read_method_for_time_zone_conversion(name)
            else
              define_read_method(name.to_sym, name, column)
            end
          end

          unless instance_method_already_implemented?("#{name}=")
            if create_time_zone_conversion_attribute?(name, column)
              define_write_method_for_time_zone_conversion(name)
            elsif self.marshalized_attributes[name]
              define_write_method_for_marshalized_attribute(name.to_sym)
            else
              define_write_method(name.to_sym)
            end
          end

          unless instance_method_already_implemented?("#{name}?")
            define_question_method(name)
          end
        end

        # attempt to have a call to super...
        # it implies refactoring much of the columns handling in base.rb,
        # because super (the original define_attribute_methods) calls
        # several helpers which mess up with the prior marshalized 
        # attributes definition process: columns_hash(), calling columns(), 
        # hence the current connection.
        #
        # that's why it's a TODO and will probably stay as it
        
        #marshalized_attributes.each do |name, class_name|
          #unless instance_method_already_implemented?(name)
            #define_read_method_for_marshalized_attribute(name)
          #end

          #unless instance_method_already_implemented?("#{name}=")
            #define_write_method_for_marshalized_attribute(name.to_sym)
          #end

          #unless instance_method_already_implemented?("#{name}?")
            #define_question_method(name)
          #end
        #end

        #generated_methods.clear
        #@columns_hash.delete_if {|column_name, column| marshalized_attributes.has_key?(column_name) } 
        #super
        #columns_hash
        ## TODO must add the suffix versions (= ?)
        #generated_methods.merge(marshalized_attributes.keys)
      end

      # Define read method for marshalized attribute.
      def define_read_method_for_marshalized_attribute(attr_name)
        evaluate_attribute_method attr_name, "def #{attr_name}; unmarshalize_attribute('#{attr_name.to_sym}'); end"
      end

      def define_write_method_for_marshalized_attribute(attr_name)
        evaluate_attribute_method attr_name, "def #{attr_name}=(new_value); marshalize_attribute('#{attr_name.to_sym}', new_value); end", "#{attr_name}="
      end

    end # class: Marshalization::AttributeMethods::ClassMethods

    # Initialize an empty marshalized attribute.
    # Prevents initialization error (marshal: data too short)
    def initialize_marshalized_attribute(name, class_name)
      @attributes[name] = encode_attribute(Marshal.dump(class_name.new))
    end

    def read_attribute(attr_name)
      attr_name = attr_name.to_s
      if !(value = @attributes[attr_name]).nil?
        if column = column_for_attribute(attr_name)
          if unmarshalizable_attribute?(attr_name, column)
            unmarshalize_attribute(attr_name.to_sym)
          else
            super(attr_name.to_sym)
          end
        end
      else
      end
    end

    def marshalize_attribute(attr_name, value)
      attr_name = attr_name.to_s
      @attributes_cache.delete(attr_name)
      if self.class.marshalized_attributes[attr_name]
        dumped = encode_attribute(Marshal.dump(value))
        @attributes[attr_name] = dumped
      end
    end

    # Returns the unmarshalized object of the attribute.
    def unmarshalize_attribute(attr_name)
      attr_name = attr_name.to_s
      if @attributes[attr_name].nil? || @attributes[attr_name] == ''
        initialize_marshalized_attribute(attr_name, self.class.marshalized_attributes[attr_name])
      end
      unmarshalized_object = Marshal.load(decode_attribute(@attributes[attr_name]))

      if unmarshalized_object.is_a?(self.class.marshalized_attributes[attr_name]) || unmarshalized_object.nil?
        return unmarshalized_object
      else
        raise ActiveRecord::SerializationTypeMismatch,
              "#{attr_name} was supposed to be a #{self.class.marshalized_attributes[attr_name]}, but was a #{unmarshalized_object.class.to_s}"
      end
    end

    # Returns true if the attribute is of a text column and marked for marshalization.
    def unmarshalizable_attribute?(attr_name, column)
      column.text? && self.class.marshalized_attributes[attr_name]
    end

    def self.included(receiver)
      receiver.send :extend, ClassMethods
    end

  end # module: Marshalization::AttributeMethods

end # module: Marshalization
