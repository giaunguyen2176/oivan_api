class ApplicationController < ActionController::API
  include ActionView::Layouts

  def redirect
    render file: 'public/404.html', status: :not_found, layout: false if params[:key].blank?

    decoded = HASHIDS.decode(params[:key])

    render file: 'public/404.html', status: :not_found, layout: false if decoded.blank?

    origin = Url.find_by(id: decoded[0])

    render file: 'public/404.html', status: :not_found, layout: false if origin.blank?

    redirect_to origin.url, allow_other_host: true
  end
end
