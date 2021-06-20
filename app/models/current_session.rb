class CurrentSession < ActiveSupport::CurrentAttributes
  attribute :user

  delegate :id, :name, to: :user, allow_nil: true, prefix: true
end