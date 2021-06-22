json.data do
  if @resource.blank?
    json.null!
  else
    json.partial! 'api/v1/addresses/form', resource: @resource
  end
end
