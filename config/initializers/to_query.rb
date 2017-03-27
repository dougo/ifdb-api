class NilClass
  # Override Object's to_query, which appends '='.
  # This makes Rack::Utils.parse_query('foo').to_query == 'foo' instead of 'foo='.
  def to_query(key)
    key
  end
end
