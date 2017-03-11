class SourceTypeName < ActiveRecord::Type::String
  attr_accessor :name_map

  def initialize(name_map)
    @name_map = name_map.freeze
    @abbrevs = name_map.invert.freeze
  end

  def serialize(type_name)
    @abbrevs[type_name]
  end

  def deserialize(type_abbrev)
    @name_map[type_abbrev]
  end
end
