class ApplicationMapper < Yaks::Mapper
  def attributes
    super.reject { |attr| load_attribute(attr.name).nil? }
  end
end
