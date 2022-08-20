class Url < ApplicationRecord
  validates :url, url: true

  def key
    HASHIDS.encode(id)
  end

  def short_url
    "#{ENV['DOMAIN']}/#{key}"
  end
end
