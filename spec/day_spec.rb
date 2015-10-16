RSpec.describe Biz::Day do
  subject(:day) { described_class.new(9) }

  context 'when initializing' do
    context 'with an integer' do
      it 'is successful' do
        expect(described_class.new(1)).to be_truthy
      end
    end

    context 'with an valid integer-like value' do
      it 'is successful' do
        expect(described_class.new('1')).to be_truthy
      end
    end

    context 'with an invalid integer-like value' do
      it 'fails hard' do
        expect { described_class.new('1one') }.to raise_error ArgumentError
      end
    end

    context 'with a non-integer value' do
      it 'fails hard' do
        expect { described_class.new([]) }.to raise_error TypeError
      end
    end
  end

  describe '.from_date' do
    let(:epoch_time) { Date.new(2006, 1, 10) }

    it 'creates the proper day' do
      expect(described_class.from_date(epoch_time).to_i).to eq 9
    end
  end

  describe '#to_date' do
    it 'returns the corresponding date since epoch' do
      expect(day.to_date).to eq Date.new(2006, 1, 10)
    end
  end

  describe '#to_i' do
    it 'returns the day since epoch' do
      expect(day.to_i).to eq 9
    end
  end
end
