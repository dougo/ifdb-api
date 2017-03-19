class HyperResource::Adapter::JSON_API < HyperResource::Adapter
  def self.serialize(object)
    JSON.dump(object)
  end

  def self.deserialize(string)
    JSON.parse(string).deep_symbolize_keys
  end

  def self.apply(doc, hr)
    apply_links(doc[:links], hr)
    data = doc[:data]
    case data
    when Hash
      apply_single_resource(data, hr)
    when Array
      apply_array_of_resources(data, hr)
    end
  end

  private

  def self.apply_links(links, hr)
    if links
      links.each do |rel, href|
        hr.links[rel] = HyperResource::Link.new(hr, href: href) # TODO: should be hr.class::Link.new
      end
      hr.href = links[:self]
    end
    hr
  end

  def self.apply_single_resource(resource, hr)
    attrs = { id: resource[:id], type: resource[:type], **resource[:attributes] }.stringify_keys
    hr.attributes.replace(attrs)
    apply_links(resource[:links], hr)
    hr.loaded = true
    hr
  end

  def self.apply_array_of_resources(resources, hr)
    hr.objects[:data] = resources.map do |resource|
      apply_single_resource(resource, HyperResource.new)
    end
    hr.loaded = true
    hr
  end
end
