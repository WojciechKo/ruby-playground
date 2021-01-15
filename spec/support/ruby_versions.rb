RSpec.shared_context 'with ruby 2.7.x' do
  around do |example|
    example.call if (2.7...3).cover?(RUBY_VERSION.to_f)
  end
end

RSpec.shared_context 'with ruby 3.0.x' do
  around do |example|
    example.call if (3...).cover?(RUBY_VERSION.to_f)
  end
end

RSpec.configure do |config|
  config.alias_it_behaves_like_to(:when_run, 'when run')

  config.include_context 'with ruby 2.7.x', ruby_version: 2.7
  config.include_context 'with ruby 3.0.x', ruby_version: 3.0
end
