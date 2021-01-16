RSpec.describe 'New methods' do
  describe 'Array' do
    describe '#intersection' do
      specify do
        expect([1, 2, 4].intersection([4, 1])).to match_array([1, 4])
        expect([1, 2, 4].intersection([1], [2, 4])).to match_array([])
      end
    end
  end

  describe 'Enumerable' do
    describe '#filter_map' do
      specify do
        expect(['1', '2', 'alfa', '3'].filter_map { |x| Integer(x, exception: false) })
          .to match_array([1, 2, 3])

        expect([1, 2, 3].filter_map { |x| x.odd? ? x.to_s : nil })
          .to match_array(['1', '3'])
      end
    end

    describe '#tally' do
      specify do
        expect(['A', 'B', 'C', 'B', 'A'].tally)
          .to eq({ 'A' => 2, 'B' => 2, 'C' => 1 })

        expect([4, 2, 3, 2, 3, 4, 1].tally)
          .to eq({ 1 => 1, 2 => 2, 3 => 2, 4 => 2 })
      end
    end
  end

  describe 'Enumerator' do
    describe '#new' do
      specify do
        fibonacci = Enumerator.new do |enumerator|
          first = 0
          second = 1

          loop do
            enumerator << first
            first, second = second, first + second
          end
        end

        expect(fibonacci.take(6)).to match_array([0, 1, 1, 2, 3, 5])
      end
    end

    describe '#produce' do
      specify do
        powers_of_two = Enumerator.produce(1) { _1 * 2}
        expect(powers_of_two.take(6)).to match_array([1, 2, 4, 8, 16, 32])
      end

      specify do
        fibonacci = Enumerator.produce([0, 1]) { |first, second| [second, first + second] }
                              .lazy
                              .map(&:first)

        expect(fibonacci.take(6)).to match_array([0, 1, 1, 2, 3, 5])
      end
    end
  end
end
