concern :CompoundID do
  class_methods do
    attr_reader :_compound_id

    def compound_id(attrs)
      @_compound_id = attrs

      primary_key :id

      define_method(:id) do
        self.class._compound_id.map(&_model.method(:send)).join '-'
      end

      filter :id, apply: ->(records, id, options) do
        records.where(_compound_id.zip(id.split('-')).to_h)
      end
    end
  end
end
