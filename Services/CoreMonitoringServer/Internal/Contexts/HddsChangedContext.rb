require "set"

class HddsChangedContext
  attr_accessor :message, :emails, :server_configuration

  def initialize()
    @emails = Set.new
  end
end