module RequestHelpers
  def auth_headers(user)
    token = JWT.encode({ user_id: user.id }, ENV.fetch('JWT_SECRET'))
    { 'Authorization' => "Bearer #{token}" }
  end

  def json
    JSON.parse(response.body)
  end
end
