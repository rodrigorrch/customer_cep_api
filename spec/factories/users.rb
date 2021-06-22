FactoryBot.define do
  factory :user do
    id { 1 }
    email { 'rodrigo@latamgateway.com' }
    password { "123456" }
    name { 'Rodrigo' }
    api_token { '4638bccdcbce5fd1ad9efcbb972b599cde4fa462' }

    initialize_with { User.where(id: id).first_or_initialize }
  end
end
