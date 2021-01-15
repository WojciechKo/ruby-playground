RSpec.describe 'Beginless and endless ranges' do
  describe 'Usage of range to slice an array' do
    let(:array) { [10, 11, 12] }

    describe 'usage of beginless range' do
      describe 'with .. definition' do
        describe 'with positive number' do
          it 'returns from the begining to provided index including', :aggregate_failures do
            expect(array[..0]).to eq([10])
            expect(array[..1]).to eq([10, 11])
            expect(array[..2]).to eq([10, 11, 12])
            expect(array[..3]).to eq([10, 11, 12])
          end
        end

        describe 'with negative number' do
          it 'returns from the begining `array.size + <provided_number> + 1` elements', :aggregate_failures do
            expect(array[..-1]).to eq([10, 11, 12])
            expect(array[..-2]).to eq([10, 11])
            expect(array[..-3]).to eq([10])
            expect(array[..-4]).to eq([])
            expect(array[..-5]).to eq([])
          end
        end
      end

      describe 'with ... definition' do
        describe 'with positive number' do
          it 'returns from the begining to provided index excluding', :aggregate_failures do
            expect(array[...0]).to eq([])
            expect(array[...1]).to eq([10])
            expect(array[...2]).to eq([10, 11])
            expect(array[...3]).to eq([10, 11, 12])
            expect(array[...4]).to eq([10, 11, 12])
          end
        end

        describe 'with negative number' do
          it 'returns from the begining `array.size + <provided_number>` elements', :aggregate_failures do
            expect(array[...-1]).to eq([10, 11])
            expect(array[...-2]).to eq([10])
            expect(array[...-3]).to eq([])
            expect(array[...-4]).to eq([])
          end
        end
      end
    end

    describe 'usage of endless range' do
      describe 'with .. definition' do
        describe 'with positive number' do
          it 'returns from provided index till the end', :aggregate_failures do
            expect(array[0..]).to eq([10, 11, 12])
            expect(array[1..]).to eq([11, 12])
            expect(array[2..]).to eq([12])
            expect(array[3..]).to eq([])
            expect(array[4..]).to eq(nil)
          end
        end

        describe 'with negative number' do
          it 'returns last `-<provided_number>` elements', :aggregate_failures do
            expect(array[-1..]).to eq([12])
            expect(array[-2..]).to eq([11, 12])
            expect(array[-3..]).to eq([10, 11, 12])
            expect(array[-4..]).to eq(nil)
          end
        end
      end

      describe 'with ... definition' do
        describe 'with positive number' do
          it 'returns from provided index till the end', :aggregate_failures do
            expect(array[0...]).to eq([10, 11, 12])
            expect(array[1...]).to eq([11, 12])
            expect(array[2...]).to eq([12])
            expect(array[3...]).to eq([])
            expect(array[4...]).to eq(nil)
          end
        end

        describe 'with negative number' do
          it 'returns last `-<provided_number>` elements', :aggregate_failures do
            expect(array[-1...]).to eq([12])
            expect(array[-2...]).to eq([11, 12])
            expect(array[-3...]).to eq([10, 11, 12])
            expect(array[-4...]).to eq(nil)
          end
        end
      end
    end
  end

  describe 'usage of range as method argument' do
    describe 'biginless .. range' do
      it 'includes number used to define range' do
        expect((..2).cover?(1)).to be(true)
        expect((..2).cover?(2)).to be(true)
        expect((..2).cover?(3)).to be(false)
      end
    end

    describe 'biginless ... range' do
      it 'does not include the number used to define range' do
        expect((...2)).to cover(1)
        expect((...2)).not_to cover(2)
        expect((...2)).not_to cover(3)
      end
    end

    describe 'endless .. range' do
      it 'includes the number used to define range' do
        expect((2..)).not_to cover(1)
        expect((2..)).to cover(2)
        expect((2..)).to cover(3)
      end
    end

    describe 'endless ... range' do
      it 'includes the number used to define range' do
        expect((2...)).not_to cover(1)
        expect((2...)).to cover(2)
        expect((2...)).to cover(3)
      end
    end
  end
end
