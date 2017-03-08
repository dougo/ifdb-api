class User < ApplicationRecord
  has_many :lists, class_name: 'RecommendedList', foreign_key: :userid
end
