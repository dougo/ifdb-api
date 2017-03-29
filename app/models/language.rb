class Language < ApplicationRecord
  self.table_name = 'iso639x'

  def self.find_by(id: nil, **args)
    if id
      id, country = id.split('-')
      case id.length
      when 2
        super(id2: id, **args)
      when 3
        super(id3: id, **args)
      end
    else
      super(**args)
    end
  end
end
