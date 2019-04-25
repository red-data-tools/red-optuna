require "numpy"

module Optuna
  class << self
    def __pyptr__
      @optuna ||= PyCall.import_module("optuna")
    end
  end

  Study = __pyptr__.Study
  class Study
    register_python_type_mapping

    class << self
      def new(*args)
        Optuna.__pyptr__.create_study(*args)
      end
    end

    def optimize(*args, &block)
      args = [block, *args] if block_given?
      super(*args)
    end
  end

  Trial = __pyptr__.Trial
  class Trial
    register_python_type_mapping
  end
end
