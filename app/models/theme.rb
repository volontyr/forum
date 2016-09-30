class Theme < ActiveRecord::Base
  belongs_to :section
  has_many :messages, dependent: :destroy	 
end
