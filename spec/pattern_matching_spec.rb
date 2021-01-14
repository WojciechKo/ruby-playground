RSpec.describe 'pattern matching' do
  context 'with an array' do
    subject(:array) { [1, 2, 3] }

    it 'matches whole array with splat' do
      case array
        in [*matched]
        expect(matched).to eq([1, 2, 3])
        else
        raise 'should not be executed'
      end
    end

    it 'does not match without splat' do
      expect do
        case array
          in [matched]
          raise 'should not be executed'
        end
      end.to raise_error(NoMatchingPatternError)
    end
  end

  context 'with a hash' do
    subject(:hash) { { a: 'a', b: 'b', c: 42 } }

    it 'matches whole hash with double splat' do
      case hash
        in {**matched}
        expect(matched).to eq(hash)
      end
    end

    it 'matches single hash value' do
      case hash
        in {a: value}
        expect(value).to eq('a')
      end
    end

    it 'matches the rest of the hash' do
      case hash
        in {a: value, **rest}
        expect(rest).to eq(b: 'b', c: 42)
      end
    end
  end
end
