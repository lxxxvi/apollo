class TokenValuesGenerator
  def self.generate_values(number = 1)
    number.times.map { SecureRandom.alphanumeric(12) }
  end
end
