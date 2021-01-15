require 'support/ruby_versions'

RSpec.describe 'Method implementation that accepts block' do
  context 'with proc call inside' do
    def foo
      proc.call
    end

    context 'when called with a block' do
      subject(:invocation) { -> { foo { 'Hello there' } } }

      when_run 'with ruby 2.7.x' do
        it { expect(invocation.call).to eq('Hello there') }
      end

      when_run 'with ruby 3.0.x' do
        it { expect { invocation.call }.to raise_error(ArgumentError, /tried to create Proc object without a block/) }
      end
    end

    context 'when called without a block' do
      subject(:invocation) { -> { foo } }

      it { expect { invocation.call }.to raise_error(ArgumentError, /tried to create Proc object without a block/) }
    end
  end

  context 'with Proc.new call inside' do
    def foo
      Proc.new.call
    end

    context 'when called with a block' do
      subject(:invocation) { -> { foo { 'Hello there' } } }

      when_run 'with ruby 2.7.x' do
        it { expect(invocation.call).to eq('Hello there') }
      end

      when_run 'with ruby 3.0.x' do
        it { expect { invocation.call }.to raise_error(ArgumentError, /tried to create Proc object without a block/) }
      end
    end

    context 'when called without a block' do
      subject(:invocation) { -> { foo } }

      it { expect { invocation.call }.to raise_error(ArgumentError, /tried to create Proc object without a block/) }
    end
  end

  context 'with lambda call inside' do
    def foo
      lambda.call
    end

    context 'when called with a block' do
      subject(:invocation) { -> { foo { 'Hello there' } } }

      it { expect { invocation.call }.to raise_error(ArgumentError, /tried to create Proc object without a block/) }
    end

    context 'when called without a block' do
      subject(:invocation) { -> { foo } }

      it { expect { invocation.call }.to raise_error(ArgumentError, /tried to create Proc object without a block/) }
    end
  end

  context 'with explicit &block argument' do
    # rubocop:disable Performance/RedundantBlockCall
    def foo(&block)
      block.call
    end
    # rubocop:enable Performance/RedundantBlockCall

    context 'when called with a block' do
      subject(:invocation) { -> { foo { 'Hello there' } } }

      it { expect(invocation.call).to eq('Hello there') }
    end

    context 'when called without a block' do
      subject(:invocation) { -> { foo } }

      it { expect { invocation.call }.to raise_error(NoMethodError, /undefined method `call' for nil:NilClass/) }
    end
  end

  context 'with explicit yield call' do
    def foo
      yield
    end

    context 'when called with a block' do
      subject(:invocation) { -> { foo { 'Hello there' } } }

      it { expect(invocation.call).to eq('Hello there') }
    end

    context 'when called without a block' do
      subject(:invocation) { -> { foo } }

      it { expect { invocation.call }.to raise_error(LocalJumpError, /no block given \(yield\)/) }
    end
  end
end
