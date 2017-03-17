ActiveRecord::Type.register(:yn_boolean) { |*args| YNBoolean.new }
ActiveRecord::Type.register(:source_type_name) { |*args, **kwargs| SourceTypeName.new(**kwargs) }
