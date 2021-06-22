FactoryBot.define do
  factory :address do
    postal_code { Faker::Address.zip_code }
    city { Faker::Address.city }
    neighborhood { Faker::Address.street_name  }
    state { Faker::Address.state_abbr }
    street { Faker::Address.street_address }
    association :user, factory: :user

    initialize_with { Address.where(postal_code: postal_code).first_or_initialize }
  end

  factory :address_sp, class: Address do
    postal_code { '01001000' }
    city { 'São Paulo' }
    neighborhood { 'Sé' }
    state { 'SP' }
    street { 'Praça da Sé - lado ímpar' }
    association :user, factory: :user

    initialize_with { Address.where(postal_code: postal_code).first_or_initialize }
  end

  factory :address_araras, class: Address do
    postal_code { '13600001' }
    city { 'Araras' }
    neighborhood { 'Centro' }
    state { 'SP' }
    street { 'Avenida Dona Renata' }
    association :user, factory: :user

    initialize_with { Address.where(postal_code: postal_code).first_or_initialize }
  end
end
