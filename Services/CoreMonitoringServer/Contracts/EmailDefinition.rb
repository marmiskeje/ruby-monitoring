require "set"

class EmailDefinition
  attr_accessor :subject, :body, :recipients
  def initialize()
    @recipients = Set.new
    @recipients.add("ruby.monitoring.miskeje@gmail.com")
  end
end