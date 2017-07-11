require_relative '../current_helper'

class EmailNormalizer
  def initialize
    @customrer_api = TurboCassandra::API::Customer.new
  end

  private
  def normalize_email customer
    normalized_email = customer['email'].downcase
    puts "#{customer['email']} vs #{normalized_email}"
    normalized_email
  end

  def update_customer_email customer, normalized_email
    @customrer_api.update_attributes customer['id'],
                                     {email: normalized_email}
  end

  public
  def run
    customers = @customrer_api.all
    regexp = /[A-Z]/
    customers.each do |customer|
      unless regexp.match(customer['email']).nil?
        normalize_email = normalize_email customer
        update_customer_email customer, normalize_email
      end
    end
  end
end

normalizer = EmailNormalizer.new
normalizer.run