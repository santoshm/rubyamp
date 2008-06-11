module RubyAMP
  # since this environment will be carried over when running specs and such, be very careful not to pollute the global namespace
  LIB_ROOT = File.dirname(__FILE__)
  RUBYAMP_ROOT = File.join(LIB_ROOT, "ruby_amp")
  
  AUTO_LOAD = {
    :Launcher       => 'launcher.rb',
    :RemoteDebugger => 'remote_debugger.rb',
    :Inspect        => 'inspect.rb',
    :PrettyAlign    => 'pretty_align.rb'
  }
  
  def self.const_missing(name)
    @looked_for ||= {}
    raise "Class not found: #{name}" if @looked_for[name]
    
    return super unless AUTO_LOAD[name]
    @looked_for[name] = true
    
    require File.join(RUBYAMP_ROOT, AUTO_LOAD[name])
    const_get(name)
  end
end
