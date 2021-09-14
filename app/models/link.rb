class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true
  validates_presence_of :name, :url
  validates :url, url: true
end
