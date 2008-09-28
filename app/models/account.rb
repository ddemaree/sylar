class Account < ActiveRecord::Base
  class NotFound < ActiveRecord::RecordNotFound; end

  ReservedSubdomains = %w(www 123 abc admin practical secure)

  has_many :users#, :accessible => true

  def self.find_by_subdomain!(subdomain)
    find_by_subdomain(subdomain) or raise NotFound.new("Could not find account with subdomain '#{subdomain}'")
  end
  
  def self.public_subdomain?(sd)
    !!ReservedSubdomains.include?(sd)
  end

end
