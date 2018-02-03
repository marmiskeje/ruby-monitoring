require_relative "ExecutableCommand"

class ErrorHandlingCommand < ExecutableCommand
  def on_execute()
    if @successor.nil? == false
      command = @successor
      @successor = nil
      begin
        command.execute()
      rescue Exception => e
        print(e.class.name + ": " + e.message)
        # todo log
      end
    end
  end
end