require File.join(File.dirname(__FILE__), 'lib', 'delegatron')
require 'minitest/autorun'

include Delegatron

class DelegatedTo
  def foo; "foo"; end
  def bar; "bar"; end
end
class Delegates
  def initialize
    set_delegate(DelegatedTo.new)
  end
end
class DelegatesAll < Delegates; include Delegator; end
class DelegatesSome < Delegates
  include SelectiveDelegator
  def initialize; delegate :foo; super; end
end

describe Delegatron do

  describe CoreDelegator do

    it "must declare set_delegate as a private method" do
      class K; include CoreDelegator; end
      assert_raises(NoMethodError){ K.new.set_delegate }
    end

  end

  describe Delegator do

    before{ @del = DelegatesAll.new }

    it "must delegate all methods to the delegate object" do
      assert_equal("foo", @del.foo)
      assert_equal("bar", @del.bar)
    end

    it "must define method_missing as a private method" do
      assert_raises(NoMethodError){ @del.method_missing }
    end

  end

  describe SelectiveDelegator do

    before{ @del = DelegatesSome.new }

    it "must delegate the selected methods" do
      assert_equal(@del.foo, "foo")
    end

    it "must not delegate non-selected methods, instead raising a NoMethodError" do
      assert_raises(NoMethodError){ @del.bar }
    end

    it "must define method_missing as a private method" do
      assert_raises(NoMethodError){ @del.method_missing }
    end

    it "must define delegate as a private method" do
      assert_raises(NoMethodError){ @del.delegate }
    end

  end

end
