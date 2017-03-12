class OperatingSystemVersion < ApplicationRecord
  self.table_name = 'osversions'

  belongs_to :operating_system, foreign_key: :osid
end
