RSpec.describe 'Regex matching' do
  describe '#=~' do
    specify do
      expect(/hay/ =~ 'haystack').to eq(0)
      expect(/ay/ =~ 'haystack').to eq(1)

      expect(/needle/ =~ 'haystack').to be_nil
    end

    specify do
      expect('haystack' =~ /hay/).to eq(0)
      expect('haystack' =~ /ay/).to eq(1)

      expect('haystack' =~ /needle/).to be_nil
    end
  end

  describe '#match' do
    let(:url) { 'https://docs.ruby-lang.org/en/2.5.0/MatchData.html' }

    it 'works both way' do
      expect(/ay/.match('haystack')).to have_attributes(to_a: ['ay'])
      expect(/needle/.match('haystack')).to be_nil

      expect('haystack'.match(/ay/)).to have_attributes(to_a: ['ay'])
      expect('haystack'.match(/needle/)).to be_nil
    end

    it 'returns captures' do
      expect(url.match(/(\d\.?)+/)).to(
        have_attributes(
          to_a: ['2.5.0', '0'],
          captures: ['0'],
          named_captures: {}
        )
      )

      expect(url.match(%r{([^/]+)/([^/]+)\.html$})).to(
        have_attributes(
          to_a: ['2.5.0/MatchData.html', '2.5.0', 'MatchData'],
          captures: ['2.5.0', 'MatchData'],
          named_captures: {}
        )
      )
    end

    it 'returns named_captures' do
      expect(url.match(%r{(?<version>[^/]+)/(?<module>[^/]+)\.html$})).to(
        have_attributes(
          to_a: ['2.5.0/MatchData.html', '2.5.0', 'MatchData'],
          captures: ['2.5.0', 'MatchData'],
          named_captures: { 'version' => '2.5.0', 'module' => 'MatchData' }
        )
      )
    end
  end
end
