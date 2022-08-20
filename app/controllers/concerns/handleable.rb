module Handleable
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotUnique, with: :record_not_unique
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_record
    rescue_from ActionController::BadRequest, with: :bad_request
    rescue_from ActionController::ParameterMissing, with: :param_missing
    rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key
    rescue_from ActionError, with: :custom_error
  end

  def custom_error(exception)
    render_error(
      [exception.to_s],
      :ok
    )
  end

  def record_not_unique(exception)
    render_error(
      [exception.to_s],
      :ok
    )
  end

  def record_not_found(exception)
    render_error(
      [exception.to_s],
      :ok
    )
  end

  def unprocessable_record(exception)
    render_error(
      exception.record.errors.full_messages,
      :ok
    )
  end

  def param_missing(exception)
    render_error(
      [exception.to_s],
      :bad_request
    )
  end

  def bad_request(exception)
    render_error(
      [exception.to_s],
      :bad_request
    )
  end

  def invalid_foreign_key
    render_error(
      ['Violates foreign key constraint'],
      :unprocessable_entity
    )
  end

  private

  def render_error(messages, status, error_code: 1)
    render json: { data: nil, success: false, messages: messages, error_code: error_code }, status: status
  end
end
