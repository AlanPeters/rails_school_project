json.extract! student, :id, :name, :status, :idnumber, :created_at, :updated_at
json.url student_url(student, format: :json)
