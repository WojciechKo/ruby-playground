RSpec.describe 'Numbered parameters' do
  describe 'usage of single default argument' do
    subject { [1, 2, 3].map { _1 + 10 } }

    it { is_expected.to eq([11, 12, 13]) }
  end

  describe 'usage of multiple default arguments' do
    subject { [[1, 2], [3, 4]].map { _1 + _2 } }

    it { is_expected.to eq([3, 7]) }
  end

  describe 'usage of named and default argument' do
    subject { eval '[1, 2, 3].map { |number| number + _1 }' }

    it 'is forbidden' do
      expect { subject }
        .to raise_error(SyntaxError, /ordinary parameter is defined/)
    end
  end
end
