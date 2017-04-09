class HyperResource::Adapter::JSON_API < HyperResource::Adapter
  def self.serialize(object)
    JSON.dump(object)
  end

  def self.deserialize(string)
    JSON.parse(string).deep_symbolize_keys
  end

  def self.apply(doc, hr)
    apply_primary_data(doc[:data], doc[:included], hr)
    apply_links(doc[:links], hr)
    hr
  end

  private

  def self.apply_primary_data(data, included, hr)
    case data
    when Hash
      apply_resource(data, included, hr)
    when Array
      apply_resources(data, included, hr)
    end
  end

  def self.apply_resource(resource, included, hr)
    # TODO: get from included if present
    # TODO: make an integration test for fetching a relationship, which has linkage as primary data
    apply_attributes(resource, hr)
    apply_relationships(resource[:relationships], included, hr)
    apply_links(resource[:links], hr)
  end

  # Convert the array of primary data to an array of embedded objects (under the :data key).
  def self.apply_resources(resources, included, hr)
    hr.objects[:data] = resources.map do |resource|
      hr.new_from(resource: hr, body: { data: resource, included: included })
    end
  end

  def self.apply_attributes(resource, hr)
    attrs = resource[:attributes] || {}
    attrs[:id] = resource[:id]
    attrs[:type] = resource[:type]
    attrs = attrs.map { |k,v| [ to_hr_key(k), v ] }.to_h
    hr.attributes.replace(attrs)
  end

  def self.apply_relationships(relationships, included, hr)
    if relationships
      relationships.each do |rel, relationship|
        apply_link(rel, relationship[:links][:related], hr)
        if relationship[:data]
          apply_resource_linkage(rel, relationship[:data], included, hr)
        end
      end
    end
  end

  def self.apply_resource_linkage(rel, linkage, included, hr)
    hr.objects[to_hr_key(rel)] = resolve_resource_linkage(linkage, included, hr)
  end

  def self.resolve_resource_linkage(linkage, included, hr)
    # TODO: just make a doc!
    case linkage
    when Hash
      find_included_resource(linkage, included, hr)
    when Array
      linkage.map { |rid| find_included_resource(rid, included, hr) }
    end
  end

  def self.find_included_resource(rid, included, hr)
    # TODO: this should be a hash lookup
    resource = included.find { |resource| resource[:type] == rid[:type] && resource[:id] == rid[:id] }
    # TODO: don't make a new resource each time!
    hr.new_from(resource: hr, body: { data: resource, included: included })
  end

  def self.apply_links(links, hr)
    if links
      links.each do |rel, link_spec|
        apply_link(rel, link_spec, hr)
      end
    end
  end

  def self.apply_link(rel, link_spec, hr)
    link_spec = { href: link_spec } if String === link_spec
    template = URI(link_spec[:href]).query ? '{&include}' : '{?include}'
    link = self::Link.new(hr, **link_spec.merge(href: link_spec[:href] + template, templated: true))
    hr.links[to_hr_key(rel)] = link
    hr.href = link.href if rel == :self
  end

  def self.to_hr_key(json_key)
    json_key.to_s.gsub('-', '_')
  end
end
