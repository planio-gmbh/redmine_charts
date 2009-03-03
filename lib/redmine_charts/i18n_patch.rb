unless defined? Redmine::I18n

  # Changes in Redmine 0.8.2 
  
  module GLoc
  
    def l(*args)
      case args.size
      when 1
        GLoc.l(*args)
      when 2
        if args.last.is_a?(Hash) or args.last.is_a?(Array)
          GLoc.l(args.first, *args.last)
        else
          GLoc.l(args.first, args.last)
        end
      else
        raise "Translation string with multiple values: #{args.first}"
      end
    end
  
  end

end