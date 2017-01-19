module Photos
  class Cli
    module View
      autoload :Confirm, 'photos/cli/view/confirm'
      autoload :Select, 'photos/cli/view/select'
      autoload :Input, 'photos/cli/view/input'
    end
  end
end
