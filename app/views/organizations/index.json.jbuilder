json.array!(@organizations) do |organization|
  json.extract! organization, :id, :name, :abbr, :address, :person_in_charge, :email, :tel, :fax, :contact_person, :contact_tel, :contact_fax, :start_date, :workflow_state, :user_id, :is_valid
  json.url organization_url(organization, format: :json)
end
