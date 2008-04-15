# monkey patch the RemoteInterface so we can access the context
module Debugger
  class << self
    attr_accessor :context
    attr_writer :current_frame
    
    def current_frame
      @current_frame ||= 0
    end
    
    def current_binding
      context.frame_binding(current_frame)
    end
    
    def eval_from_current_binding(cmd)
      eval(cmd, current_binding)
    end
    
    def wait_for_connection
      while Debugger.handler.interface.nil?; sleep 0.10; end
    end
  end
  
  class CommandProcessor # :nodoc:
    alias :process_commands_without_hook :process_commands
    def process_commands(context, file, line)
      Debugger.context = context
      process_commands_without_hook(context, file, line)
    end
  end
end
