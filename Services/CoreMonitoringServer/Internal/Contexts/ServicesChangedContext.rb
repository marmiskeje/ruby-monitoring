require "set"

class ServicesChangedContext
  attr_accessor :message, :emails, :server_configuration

  def initialize()
    @emails = Set.new
  end
end