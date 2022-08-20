require 'rails_helper'

RSpec.describe 'api/v1/encode', type: :request do

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

  path '/api/v1/encode' do
    post 'Shorten an url' do
      tags 'Urls'
      consumes 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          url: {
            type: :string,
            example: 'https://github.com/giaunguyen2176/oivan_api'
          }
        }
      }

      response '200', 'empty url' do
        let(:params) { }
        run_test! do |response|
          data = JSON.parse(response.body).with_indifferent_access
          expect(response.status).to eq(200)
          expect(data[:success]).to eq(false)
          expect(data[:messages][0]).to eq('Url is not a valid URL')
        end
      end

      response '200', 'invalid url' do
        let(:params) { { url: 'xxx' } }
        run_test! do |response|
          data = JSON.parse(response.body).with_indifferent_access
          expect(response.status).to eq(200)
          expect(data[:success]).to eq(false)
          expect(data[:messages][0]).to eq('Url is not a valid URL')
        end
      end

      response '200', 'no host url' do
        let(:params) { { url: 'http://' } }
        run_test! do |response|
          data = JSON.parse(response.body).with_indifferent_access
          expect(response.status).to eq(200)
          expect(data[:success]).to eq(false)
          expect(data[:messages][0]).to eq('Url is not a valid URL')
        end
      end

      response '200', 'valid url' do
        let(:params) { { url: 'http://example.com' } }
        run_test! do |response|
          data = JSON.parse(response.body).with_indifferent_access
          expect(response.status).to eq(200)
          expect(data[:success]).to eq(true)
          expect(data[:data][:url]).to eq('http://example.com')
          expect(data[:data][:short_url]).to eq("#{ENV['DOMAIN']}/#{HASHIDS.encode(data[:data][:id])}")
        end
      end
    end
  end
end
