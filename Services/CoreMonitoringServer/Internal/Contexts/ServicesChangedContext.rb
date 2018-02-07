require "set"

class ServicesChangedContext
  attr_accessor :message, :emails, :server_configuration, :server_name

  def initialize()
    @emails = Set.new
  end
end