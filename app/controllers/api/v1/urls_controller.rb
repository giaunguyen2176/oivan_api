module Api
  module V1
    class UrlsController < BaseController
      def encode
        @url = Url.create!(url: params[:url])
      end

      def decode
        raise ActionError.new("Couldn't find Url without a key") if params[:key].blank?

        decoded = HASHIDS.decode(params[:key])

        raise ActionError.new('Url is invalid') if decoded.blank?

        @url = Url.find_by(id: decoded[0])

        raise ActionError.new('Url is not found') if @url.blank?
      end
    end
  end
end