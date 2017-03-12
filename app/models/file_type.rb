class FileType < ApplicationRecord
  self.table_name = 'filetypes'

  has_many :download_help, foreign_key: :fmtid
end
