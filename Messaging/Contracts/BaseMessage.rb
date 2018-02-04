require 'date'

class BaseMessage
  attr_accessor :message_id, :created_date

  def initialize()
    @created_date = DateTime.now
  end

  def serialize()
    Marshal::dump(self)
  end

  def self.deserialize(data)
    Marshal::load(data)
  end
end