class YNBoolean < ActiveRecord::Type::Boolean
  def serialize(value)
    value ? 'Y' : 'N'
  end

  def deserialize(value_from_db)
    value_from_db != 'N'
  end
end
