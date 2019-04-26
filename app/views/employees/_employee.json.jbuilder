json.extract! employee, :id, :first_name, :last_name, :ssn, :date_of_birth, :phone, :role, :active, :created_at, :updated_at
json.url employee_url(employee, format: :json)
