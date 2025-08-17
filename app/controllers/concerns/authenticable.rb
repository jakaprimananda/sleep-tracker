# app/controllers/concerns/authenticable.rb
module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from JWT::DecodeError, with: :invalid_token
    rescue_from JWT::VerificationError, with: :invalid_token
    rescue_from JWT::ExpiredSignature, with: :expired_token
  end

  private

  def authenticate_user!
    token = request.headers["Authorization"]&.split(" ")&.last
    if token.present?
      begin
        decoded = decode_token(token)
        @current_user = User.find(decoded[:user_id])
      rescue JWT::DecodeError, JWT::VerificationError, JWT::ExpiredSignature
        # Handled by rescue_from
        nil
      end
    end

    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
  end

  def current_user
    @current_user
  end

  def decode_token(token)
    decoded = JWT.decode(token, ENV.fetch("JWT_SECRET"), true, { algorithm: "HS256" })[0]
    decoded.with_indifferent_access
  end

  def not_found
    render json: { error: "Record not found" }, status: :not_found
  end

  def invalid_token
    render json: { error: "Invalid token" }, status: :unauthorized
  end

  def expired_token
    render json: { error: "Token has expired" }, status: :unauthorized
  end
end
