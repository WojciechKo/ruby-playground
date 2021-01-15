RSpec.describe 'Method declared' do
  shared_context 'with ruby 2.7.x' do
    around do |example|
      example.call if (2.7...3).cover?(RUBY_VERSION.to_f)
    end
  end

  shared_context 'with ruby 3.0.x' do
    around do |example|
      example.call if (3...).cover?(RUBY_VERSION.to_f)
    end
  end

  shared_examples 'it works fine' do |expectation|
    specify do
      expect(invocation.call).to eq(expectation)
    end
  end

  shared_examples 'it does not work fine' do
    it 'throws ArgumentError' do
      expect do
        invocation.call
      end.to raise_error(ArgumentError)
    end
  end

  RSpec.configure do |config|
    config.alias_it_behaves_like_to(:when_run, 'when run')
  end

  # EXAMPLES

  context 'with sigle keyword argument' do
    def foo(key: 21)
      [key]
    end

    context 'when called with a splated hash with symbolized keys' do
      subject(:invocation) { -> { foo(**{ key: 32 }) } }

      include_examples 'it works fine', [32]
    end

    context 'when called with a hash with symbolized key' do
      subject(:invocation) { -> { foo({ key: 32 }) } }

      when_run 'with ruby 2.7.x' do
        include_examples 'it works fine', [32]
      end

      when_run 'with ruby 3.0.x' do
        include_examples 'it does not work fine'
      end
    end

    context 'when called with a hash with stringified key' do
      subject(:invocation) { -> { foo({ 'key' => 32 }) } }

      include_examples 'it does not work fine'
    end

    context 'when called with a splated hash with stringified keys' do
      subject(:invocation) { -> { foo(**{ 'key' => 32 }) } }

      include_examples 'it does not work fine'
    end
  end

  context 'with sigle splat keywords argument' do
    def foo(**kw)
      [kw]
    end

    context 'when called without any argument' do
      subject(:invocation) { -> { foo } }

      include_examples 'it works fine', [{}]
    end

    context 'when called with a single keyword argument' do
      subject(:invocation) { -> { foo(key: 32) } }

      include_examples 'it works fine', [{ key: 32 }]
    end

    context 'when called with a single stringified keyword argument' do
      subject(:invocation) { -> { foo('key' => 32) } }

      include_examples 'it works fine', [{ 'key' => 32 }]
    end

    context 'when called with a splated hash with symbolized key' do
      subject(:invocation) { -> { foo(**{ key: 32 }) } }

      include_examples 'it works fine', [{ key: 32 }]
    end

    context 'when called with a splated hash with stringified key' do
      subject(:invocation) { -> { foo(**{ 'key' => 32 }) } }

      include_examples 'it works fine', [{ 'key' => 32 }]
    end

    context 'when called with a hash with symbolized key' do
      subject(:invocation) { -> { foo({ key: 32 }) } }

      when_run 'with ruby 2.7.x' do
        include_examples 'it works fine', [{ key: 32 }]
      end

      when_run 'with ruby 3.0.x' do
        include_examples 'it does not work fine'
      end
    end

    context 'when called with a hash with stringified key' do
      subject(:invocation) { -> { foo({ 'key' => 32 }) } }

      include_examples 'it does not work fine'
    end
  end

  context 'with regular argument and splat keyword argument' do
    def foo(arg = {}, **kw)
      [arg, kw]
    end

    context 'when called without any argument' do
      subject(:invocation) { -> { foo } }

      include_examples 'it works fine', [{}, {}]
    end

    context 'when called with single keyword argument' do
      subject(:invocation) { -> { foo(key: 32) } }

      include_examples 'it works fine', [{}, { key: 32 }]
    end

    context 'when called with a single stringified keyword argument' do
      subject(:invocation) { -> { foo('key' => 32) } }

      include_examples 'it works fine', [{}, { 'key' => 32 }]
    end

    context 'when called with a hash with stringified key' do
      subject(:invocation) { -> { foo({ 'key' => 32 }) } }

      include_examples 'it works fine', [{ 'key' => 32 }, {}]
    end

    context 'when called with a hash with symbolized keys' do
      subject(:invocation) { -> { foo({ key: 32 }) } }

      when_run 'with ruby 2.7.x' do
        include_examples 'it works fine', [{}, { key: 32 }]
      end

      when_run 'with ruby 3.0.x' do
        include_examples 'it works fine', [{ key: 32 }, {}]
      end
    end
  end

  context 'with regular argument and sigle keyword argument' do
    def foo(arg, key: 21)
      [arg, key]
    end

    context 'when called with a hash with symbolized key' do
      subject(:invocation) { -> { foo({ key: 32 }) } }

      include_examples 'it works fine', [{ key: 32 }, 21]
    end

    context 'when called with a hash with stringified key' do
      subject(:invocation) { -> { foo({ 'key' => 32 }) } }

      include_examples 'it works fine', [{ 'key' => 32 }, 21]
    end

    context 'when called with a single stringified keyword argument' do
      subject(:invocation) { -> { foo('key' => 32) } }

      when_run 'with ruby 2.7.x' do
        include_examples 'it works fine', [{ 'key' => 32 }, 21]
      end

      when_run 'with ruby 3.0.x' do
        include_examples 'it does not work fine'
      end
    end

    context 'when called with a keyword argument' do
      subject(:invocation) { -> { foo(key: 32) } }

      when_run 'with ruby 2.7.x' do
        include_examples 'it works fine', [{ key: 32 }, 21]
      end

      when_run 'with ruby 3.0.x' do
        include_examples 'it does not work fine'
      end
    end
  end

  context 'with regular argument' do
    def foo(arg = {})
      [arg]
    end

    context 'when called with a single stringified keyword argument' do
      subject(:invocation) { -> { foo('key' => 32) } }

      include_examples 'it works fine', [{ 'key' => 32 }]
    end

    context 'when called with a single keyword argument' do
      subject(:invocation) { -> { foo(key: 32) } }

      include_examples 'it works fine', [{ key: 32 }]
    end
  end

  context 'with a regular argument with default value and sigle keyword argument' do
    def foo(arg = {}, key: 21)
      [arg, key]
    end

    context 'when called with a single keyword argument' do
      subject(:invocation) { -> { foo(key: 32) } }

      include_examples 'it works fine', [{}, 32]
    end

    context 'when called with a single stringified keyword argument' do
      subject(:invocation) { -> { foo('key' => 32) } }

      when_run 'with ruby 2.7.x' do
        include_examples 'it works fine', [{ 'key' => 32 }, 21]
      end

      when_run 'with ruby 3.0.x' do
        include_examples 'it does not work fine'
      end
    end

    context 'when called with stringified keyword argument and symbolized one' do
      subject(:invocation) { -> { foo(key: 32, 'key' => 43) } }

      when_run 'with ruby 2.7.x' do
        include_examples 'it works fine', [{ 'key' => 43 }, 32]
      end

      when_run 'with ruby 3.0.x' do
        include_examples 'it does not work fine'
      end
    end

    context 'when called with a hash with string and symbol as keys' do
      subject(:invocation) { -> { foo({ 'key' => 32, key: 43 }) } }

      when_run 'with ruby 2.7.x' do
        include_examples 'it works fine', [{ 'key' => 32 }, 43]
      end

      when_run 'with ruby 3.0.x' do
        include_examples 'it works fine', [{ 'key' => 32, key: 43 }, 21]
      end
    end

    context 'when called with a hash and keyword argument' do
      subject(:invocation) { -> { foo({ 'key' => 32 }, key: 43) } }

      include_examples 'it works fine', [{ 'key' => 32 }, 43]
    end
  end
end
