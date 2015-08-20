json.array!(@administrators) do |administrator|
  json.extract! administrator, :id, :name, :password_digest, :last_login_time
  json.url administrator_url(administrator, format: :json)
end
