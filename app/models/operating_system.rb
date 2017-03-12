class OperatingSystem < ApplicationRecord
  self.table_name = 'operatingsystems'

  has_many :versions, class_name: 'OperatingSystemVersion', foreign_key: :osid
end
