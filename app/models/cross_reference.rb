class CrossReference < ApplicationRecord
  self.table_name = 'gamexrefs'

  belongs_to :from, class_name: 'Game', foreign_key: :fromid
  belongs_to :to, class_name: 'Game', foreign_key: :toid
  belongs_to :type, class_name: 'CrossReferenceType', foreign_key: :reftype
end

