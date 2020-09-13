class Object
  # list methods which aren't in superclass
  def local_methods(obj = self)
    (obj.methods - obj.class.superclass.instance_methods).sort
  end
end

# require 'what_methods'
require 'amazing_print'
AmazingPrint.pry!

# Make app and helper helpers work in zeus console
# (zeus doesn't load the pry-rails 'console do' block)
if defined?(::Rails) && Rails.env
  if Rails::VERSION::MAJOR == 3
    verbose, $VERBOSE = $VERBOSE, nil
    Rails::Console::IRB = ::Pry unless Rails::Console::IRB == ::Pry
    $VERBOSE = verbose

    unless defined? ::Pry::ExtendCommandBundle
      ::Pry::ExtendCommandBundle = Module.new
    end
  end

  if Rails::VERSION::MAJOR == 4
    unless Rails.application.config.console == ::Pry
      Rails.application.config.console = ::Pry
    end
  end

  if ((Rails::VERSION::MAJOR == 3 && Rails::VERSION::MINOR >= 2) ||
      Rails::VERSION::MAJOR == 4)
    unless defined? ::Rails::ConsoleMethods
      require 'rails/console/app'
      require 'rails/console/helpers'

      TOPLEVEL_BINDING.eval('self').extend ::Rails::ConsoleMethods
    end
  end
end
