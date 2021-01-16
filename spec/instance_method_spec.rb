RSpec.describe 'Module#instance_method' do
  let(:arrays) { [['a', 'b'], ['c'], ['d', 'e']] }
  let(:hashs) { [{ 'a' => 1 }, { 'b' => 2, 'c' => 3 }, { 'd' => 4, 'e' => 5 }] }

  specify do
    expect(arrays[0].zip(*arrays[1..]))
      .to match_array([['a', 'c', 'd'], ['b', nil, 'e']])

    expect(Array.instance_method(:zip).bind_call(*arrays))
      .to match_array([['a', 'c', 'd'], ['b', nil, 'e']])
  end

  specify do
    expect(arrays[0].product(*arrays[1..]))
      .to match_array([['a', 'c', 'd'], ['a', 'c', 'e'], ['b', 'c', 'd'], ['b', 'c', 'e']])

    expect(Array.instance_method(:product).bind_call(*arrays))
      .to match_array([['a', 'c', 'd'], ['a', 'c', 'e'], ['b', 'c', 'd'], ['b', 'c', 'e']])
  end

  specify do
    expect(hashs[0].merge(*hashs[1..]))
      .to eq({ 'a' => 1, 'b' => 2, 'c' => 3, 'd' => 4, 'e' => 5 })

    expect(Hash.instance_method(:merge).bind_call(*hashs))
      .to eq({ 'a' => 1, 'b' => 2, 'c' => 3, 'd' => 4, 'e' => 5 })
  end
end
