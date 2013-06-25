require_relative '../concerns/persistable'
require_relative '../concerns/findable'

class Student

  extend  Persistable::ClassMethods
  include Persistable::InstanceMethods

  extend  Findable::ClassMethods

  ATTRIBUTES = {
    :id => "INTEGER PRIMARY KEY",
    :name => "TEXT",
    :url => "TEXT",
    :img => "TEXT",
    :tagline => "TEXT",
    :bio => "TEXT",
    :prof_pic => "TEXT",
    :twitter => "TEXT",
    :linkedin => "TEXT",
    :github => "TEXT",
    :blog => "TEXT",
    :quote => "TEXT"
  }

  def self.attributes
    ATTRIBUTES
  end

  def attributes
    self.class.attributes.keys.collect do |attribute|
      self.send(attribute)
    end
  end

  def self.attr_accessors
    self.attributes.keys.each do |k|
      attr_accessor k
    end
  end
  attr_accessors

  find_by(self.attributes.keys)

  def self.db
    @@db ||= SQLite3::Database.new('student.db')
  end

end