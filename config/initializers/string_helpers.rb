module StringHelpers
  def parse_from_json
    return nil if blank?

    JSON.parse(self)
  rescue JSON::ParserError => _error
    nil
  end

  def valid_json?
    hash = JSON.parse(self)
    hash.is_a?(Hash) || hash.is_a?(Array)
  rescue JSON::ParserError => _error
    false
  end

  def only_numbers
    gsub(/\D/, '')
  end
end

class String
  include StringHelpers
end
