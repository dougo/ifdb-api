class NewsItem < ApplicationRecord
  self.table_name = 'news'

  attribute :source, :source_type_name, name_map: { 'C' => 'Competition', 'G' => 'Game', 'U' => 'Club' }

  belongs_to :newsworthy, polymorphic: true, foreign_key: :sourceid, foreign_type: :source
  belongs_to :reporter, class_name: 'Member', foreign_key: :userid
  belongs_to :superseded_item, class_name: 'NewsItem', foreign_key: :supersedes
  has_one :superseding_item, class_name: 'NewsItem', foreign_key: :supersedes
  belongs_to :original_item, class_name: 'NewsItem', foreign_key: :original
  has_many :superseding_items, class_name: 'NewsItem', foreign_key: :original
end
