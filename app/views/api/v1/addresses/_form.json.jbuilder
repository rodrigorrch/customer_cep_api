json.extract! resource,
                :id, :city, :neighborhood, :state, :street, :postal_code

json.user resource.user_name
json.url api_v1_address_url resource