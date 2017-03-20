class HyperResource::Adapter::JSON_API < HyperResource::Adapter
  def self.serialize(object)
    JSON.dump(object)
  end

  def self.deserialize(string)
    JSON.parse(string).deep_symbolize_keys
  end

  def self.apply(json, hr)
    if json.key?(:data)
      apply_document(json, hr)
    else
      apply_resource(json, hr)
    end
  end

  private

  def self.apply_document(doc, hr)
    apply_primary_data(doc[:data], hr)
    apply_links(doc[:links], hr)
  end

  def self.apply_primary_data(data, hr)
    case data
    when Hash
      apply_resource(data, hr)
    when Array
      apply_resources(data, hr)
    end
  end

  def self.apply_resource(resource, hr)
    attrs = { id: resource[:id], type: resource[:type], **resource[:attributes] }.stringify_keys
    hr.attributes.replace(attrs)
    apply_relationships(resource[:relationships], hr)
    apply_links(resource[:links], hr)
  end

  # Convert the array of primary data to an array of embedded objects (under the :data key).
  def self.apply_resources(resources, hr)
    hr.objects[:data] = resources.map do |resource|
      hr.new_from(resource: hr, body: resource)
    end
    hr
  end

  def self.apply_relationships(relationships, hr)
    if relationships
      relationships.each do |rel, relationship|
        apply_link(rel, relationship[:links][:related], hr)
      end
    end
    hr
  end

  def self.apply_links(links, hr)
    if links
      links.each do |rel, href|
        apply_link(rel, href, hr)
      end
    end
    hr
  end

  def self.apply_link(rel, href, hr)
    hr.links[rel] = HyperResource::Link.new(hr, href: href) # TODO: should be hr.class::Link.new - TDD this
    hr.href = href if rel == :self
    hr
  end
end
