class DownloadHelp < ApplicationRecord
  self.table_name = 'downloadhelp'

  belongs_to :file_type, foreign_key: :fmtid
  belongs_to :operating_system, foreign_key: :osid
  belongs_to :operating_system_version, foreign_key: :osvsnid
end
