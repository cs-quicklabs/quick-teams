json.projects do
  json.array!(@projects) do |project|
    json.name project.name
    json.url project_path(project)
  end
end

json.employees do
  json.array!(@employees) do |employee|
    json.name employee.first_name + " " + employee.last_name
    json.url person_path(employee)
  end
end
