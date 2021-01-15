RSpec.describe 'Argument forwarding' do
  subject(:object_under_test) { FooClass.new(inner_object) }

  before do
    stub_const('FooClass', Class.new do
      def initialize(object)
        @object = object
      end

      def foo(...)
        @object.foo(...)
      end
    end)
  end

  let(:inner_object) { double.as_null_object }

  it 'works with simple arguments' do
    object_under_test.foo('alpha')

    expect(inner_object).to have_received(:foo).with('alpha')
  end

  it 'works with keyword arguments' do
    object_under_test.foo(beta: :delta)

    expect(inner_object).to have_received(:foo).with(beta: :delta)
  end

  it 'works with block' do
    block_to_pass = -> { object_id }
    object_under_test.foo(&block_to_pass)

    expect(inner_object).to have_received(:foo) do |&block|
      expect(block).to be(block_to_pass)
    end
  end
end
