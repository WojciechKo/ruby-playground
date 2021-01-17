require 'support/ruby_versions'

RSpec.describe 'Arguments forwarding' do
  describe 'forwarding every argument' do
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

  describe 'forwarding with leading arguments' do
    let(:bar_class) do
      eval <<-RUBY
        stub_const('BarClass', Class.new do
          def initialize(object)
            @object = object
          end

          def bar(name, ...w)
            @object.send(name, ...)
          end
        end)
      RUBY
    end

    when_run 'with ruby 2.7.x' do
      it 'throws SyntaxError' do
        expect { bar_class }
          .to raise_error(SyntaxError, /syntax error, unexpected \(\.\.\./)
      end
    end

    when_run 'with ruby 3.0.x' do
      subject(:object_under_test) { bar_class.new(inner_object) }

      let(:inner_object) { double.as_null_object }

      it 'works with simple arguments' do
        object_under_test.bar('alpha', 'beta')

        expect(inner_object).to have_received(:alpha).with('beta')
      end

      it 'works with keyword arguments' do
        object_under_test.bar(:alpha, beta: :delta)

        expect(inner_object).to have_received(:alpha).with(beta: :delta)
      end

      it 'works with block' do
        block_to_pass = -> { object_id }
        object_under_test.bar('alpha', &block_to_pass)

        expect(inner_object).to have_received(:alpha) do |&block|
          expect(block).to be(block_to_pass)
        end
      end
    end
  end
end
