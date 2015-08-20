json.array!(@users) do |user|
  json.extract! user, :id, :name, :logon_name, :password_digest, :is_valid, :is_leader, :is_admin
  json.url user_url(user, format: :json)
end
