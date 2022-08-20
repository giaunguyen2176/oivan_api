require 'rails_helper'

RSpec.describe Url, type: :model do
  let(:url) do
    build(:url)
  end

  it 'is valid' do
    expect(url).to be_valid
  end

  it 'is invalid if empty url' do
    url.url = nil
    expect(url).not_to be_valid
  end

  it 'is invalid if invalid url' do
    url.url = 'xxx'
    expect(url).not_to be_valid
  end

  it 'is invalid if empty host' do
    url.url = 'http://'
    expect(url).not_to be_valid
  end
end
