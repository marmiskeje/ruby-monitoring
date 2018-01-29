class ExecutableCommandChainCreator
  def initialize()
    @first_command = nil
    @last_command = nil
  end

  def first_command
    @first_command
  end

  def add(command)
    if @first_command.nil?
      @first_command = command
      @last_command = command
    else
      @last_command.successor = command
      @last_command = command
    end
  end
    
end