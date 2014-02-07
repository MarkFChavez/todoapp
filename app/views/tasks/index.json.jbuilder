json.array!(@tasks) do |task|
  json.extract! task, :id, :name, :finished
  json.url task_url(task, format: :json)
end
