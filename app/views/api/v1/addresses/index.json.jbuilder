json.data do
  json.array! @resource_collection do |resource|
    json.partial! 'api/v1/addresses/form', resource: resource
  end
end

json.partial! "shared/pagination", collection: @resource_collection