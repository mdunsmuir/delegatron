require 'set'

module Delegatron

  module CoreDelegator
    private
    def set_delegate(obj);
      @delegate = obj;
    end
  end

  module Delegator

    include CoreDelegator

    private

    def method_missing(meth, *args)
      if defined?(@delegate) and @delegate.respond_to?(meth)
        @delegate.method(meth).call(*args)
      else
        super
      end
    end

  end

  module SelectiveDelegator

    include CoreDelegator

    private

    def method_missing(meth, *args)
      if defined?(@delegated_methods) and defined?(@delegate) and
          @delegated_methods.include?(meth) and @delegate.respond_to?(meth)
        @delegate.method(meth).call(*args)
      else
        super
      end
    end

    def delegate(meth)
      raise ArgumentError.new("invalid method ID") unless meth.is_a?(Symbol) or meth.is_a?(String)
      @delegated_methods ||= Set.new
      @delegated_methods.add(meth)
    end

  end

end
