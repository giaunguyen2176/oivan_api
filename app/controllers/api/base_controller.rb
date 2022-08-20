module Api
  class BaseController < ApplicationController
    layout 'api'

    include Handleable
  end
end