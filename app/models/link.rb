class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, http_url: true

  def gist?
    self.url.start_with? 'https://gist.github.com/'
  end
end
