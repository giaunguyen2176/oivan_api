require 'rails_helper'

RSpec.describe 'api/v1/decode', type: :request do

  after do |example|
    example.metadata[:response][:content] = {
      'application/json' => {
        examples: {
          example.metadata[:example_group][:description] => {
            value: JSON.parse(response.body, symbolize_names: true)
          }
        }
      }
    }
  end

  path '/api/v1/decode' do
    get 'Decode an url' do
      tags 'Urls'
      consumes 'application/json'
      parameter name: :key, in: :query, type: :string

      response '200', 'empty key' do
        let(:key) { }
        run_test! do |response|
          data = JSON.parse(response.body).with_indifferent_access
          expect(response.status).to eq(200)
          expect(data[:success]).to eq(false)
          expect(data[:messages][0]).to eq("Couldn't find Url without a key")
        end
      end

      response '200', 'invalid key' do
        let(:key) { '92lkasjd' }
        run_test! do |response|
          data = JSON.parse(response.body).with_indifferent_access
          expect(response.status).to eq(200)
          expect(data[:success]).to eq(false)
          expect(data[:messages][0]).to eq("Url is invalid")
        end
      end

      response '200', 'decoded id not found' do
        let(:key) { HASHIDS.encode(1000) }
        run_test! do |response|
          data = JSON.parse(response.body).with_indifferent_access
          expect(response.status).to eq(200)
          expect(data[:success]).to eq(false)
          expect(data[:messages][0]).to eq('Url is not found')
        end
      end

      response '200', 'valid key' do
        let(:url) { create(:url) }
        let(:key) { url.key }
        run_test! do |response|
          data = JSON.parse(response.body).with_indifferent_access
          expect(response.status).to eq(200)
          expect(data[:success]).to eq(true)
          expect(data[:data][:id]).to eq(url.id)
          expect(data[:data][:url]).to eq(url.url)
          expect(data[:data][:key]).to eq(url.key)
          expect(data[:data][:short_url]).to eq(url.short_url)
        end
      end
    end
  end
end
