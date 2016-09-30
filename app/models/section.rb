class Section < ActiveRecord::Base
  has_many :themes, dependent: :destroy
  has_many :messages, through: :themes
end
