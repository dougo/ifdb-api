class HyperResource::Adapter::JSON_API::Link < HyperResource::Link
  attr_accessor :meta

  def initialize(resource, link_spec={})
    super
    meta = link_spec[:meta]
    self.meta = HyperResource::Attributes.new(resource).replace(meta.stringify_keys) if meta
  end
end
