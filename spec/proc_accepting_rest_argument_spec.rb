require 'support/ruby_versions'

RSpec.describe 'Proc accepting rest argumet' do
  describe 'proc accepting a single rest argument' do
    subject(:pr) { proc { |*args| { args: args } } }

    context 'when invoked with a regular argument and keyword arguments' do
      subject(:invocation) { -> { pr.call(1, a: 1) } }

      specify do
        expect(invocation.call).to eq({ args: [1, { a: 1 }] })
      end
    end

    context 'when invoked with an array as the only argument' do
      subject(:invocation) { -> { pr.call([1, 2]) } }

      specify do
        expect(invocation.call).to eq(args: [[1, 2]])
      end
    end

    context 'when invoked with an array that includes hash at the last position' do
      subject(:invocation) { -> { pr.call([1, { a: 1 }]) } }

      specify do
        expect(invocation.call).to eq({ args: [[1, { a: 1 }]] })
      end
    end
  end

  describe 'proc accepting a single rest argument and keywords`' do
    subject(:pr) { proc { |*args, **kw| { args: args, kw: kw } } }

    context 'when invoked with a regular argument and keyword arguments' do
      subject(:invocation) { -> { pr.call(1, a: 1) } }

      specify do
        expect(invocation.call).to eq({ args: [1], kw: { a: 1 } })
      end
    end

    context 'when invoked with an array as the only argument' do
      subject(:invocation) { -> { pr.call([1, 2]) } }

      when_run 'with ruby 2.7.x' do
        specify do
          expect(invocation.call).to eq({ args: [1, 2], kw: {} })
        end
      end

      when_run 'with ruby 3.0.x' do
        specify do
          expect(invocation.call).to eq({ args: [[1, 2]], kw: {} })
        end
      end
    end

    context 'when invoked with an array that includes hash at the last position' do
      subject(:invocation) { -> { pr.call([1, { a: 1 }]) } }

      when_run 'with ruby 2.7.x' do
        specify do
          expect(invocation.call).to eq({ args: [1], kw: { a: 1 } })
        end
      end

      when_run 'with ruby 3.0.x' do
        specify do
          expect(invocation.call).to eq({ args: [[1, { a: 1 }]], kw: {} })
        end
      end
    end
  end
end
