json.array!(@shebao_bases) do |shebao_basis|
  json.extract! shebao_basis, :id, :base, :year, :user_id
  json.url shebao_basis_url(shebao_basis, format: :json)
end
