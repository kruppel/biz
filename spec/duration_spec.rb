RSpec.describe Biz::Duration do
  subject(:duration) {
    described_class.new(in_seconds(days: 2, hours: 5, minutes: 9, seconds: 30))
  }

  context 'when initializing' do
    context 'with an integer' do
      it 'is successful' do
        expect(described_class.new(1).in_seconds).to eq 1
      end
    end

    context 'with an valid integer-like value' do
      it 'is successful' do
        expect(described_class.new('1').in_seconds).to eq 1
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

  describe '#with_unit' do
    context 'when called with a supported unit' do
      it 'returns the proper duration' do
        expect(described_class.with_unit(1, :day)).to eq(
          described_class.days(1)
        )
      end
    end

    context 'when called with an unsupported unit' do
      it 'fails hard' do
        expect { described_class.with_unit(1, :parsec) }.to raise_error(
          ArgumentError
        )
      end
    end
  end

  describe '.seconds' do
    it 'returns the proper duration' do
      expect(described_class.seconds(60)).to eq(
        described_class.new(in_seconds(seconds: 60))
      )
    end
  end

  describe '.second' do
    it 'returns the proper duration' do
      expect(described_class.second(60)).to eq(
        described_class.new(in_seconds(seconds: 60))
      )
    end
  end

  describe '.minutes' do
    it 'returns the proper duration' do
      expect(described_class.minutes(60)).to eq(
        described_class.new(in_seconds(minutes: 60))
      )
    end
  end

  describe '.minute' do
    it 'returns the proper duration' do
      expect(described_class.minute(60)).to eq(
        described_class.new(in_seconds(minutes: 60))
      )
    end
  end

  describe '.hours' do
    it 'returns the proper duration' do
      expect(described_class.hours(1)).to eq(
        described_class.new(in_seconds(hours: 1))
      )
    end
  end

  describe '.hour' do
    it 'returns the proper duration' do
      expect(described_class.hour(1)).to eq(
        described_class.new(in_seconds(hours: 1))
      )
    end
  end

  describe '.days' do
    it 'returns the proper duration' do
      expect(described_class.days(1)).to eq(
        described_class.new(in_seconds(days: 1))
      )
    end
  end

  describe '.day' do
    it 'returns the proper duration' do
      expect(described_class.day(1)).to eq(
        described_class.new(in_seconds(days: 1))
      )
    end
  end

  describe '#in_seconds' do
    it 'returns the number of seconds' do
      expect(duration.in_seconds).to eq(
        in_seconds(days: 2, hours: 5, minutes: 9, seconds: 30)
      )
    end
  end

  describe '#in_minutes' do
    it 'returns the number of whole minutes' do
      expect(duration.in_minutes).to eq((2 * 24 + 5) * 60 + 9)
    end
  end

  describe '#in_hours' do
    it 'returns the number of whole hours' do
      expect(duration.in_hours).to eq 2 * 24 + 5
    end
  end

  describe '#in_days' do
    it 'returns the number of whole days' do
      expect(duration.in_days).to eq 2
    end
  end

  describe '#+' do
    let(:duration_1) { described_class.hours(1) }
    let(:duration_2) { described_class.minutes(30) }

    it 'adds the durations' do
      expect(duration_1 + duration_2).to eq described_class.minutes(90)
    end
  end

  describe '#-' do
    let(:duration_1) { described_class.hours(1) }
    let(:duration_2) { described_class.minutes(30) }

    it 'subtracts the durations' do
      expect(duration_1 - duration_2).to eq described_class.minutes(30)
    end
  end

  describe '#positive?' do
    context 'when the duration is zero' do
      let(:duration) { described_class.new(0) }

      it 'returns false' do
        expect(duration.positive?).to eq false
      end
    end

    context 'when the duration is negative' do
      let(:duration) { described_class.new(-1) }

      it 'returns false' do
        expect(duration.positive?).to eq false
      end
    end

    context 'when the duration is positive' do
      let(:duration) { described_class.new(1) }

      it 'returns true' do
        expect(duration.positive?).to eq true
      end
    end
  end

  describe '#abs' do
    context 'when the duration is zero' do
      let(:duration) { described_class.new(0) }

      it 'returns an equivalent duration' do
        expect(duration.abs).to eq duration
      end
    end

    context 'when the duration is negative' do
      let(:duration) { described_class.new(-1) }

      it 'returns a positive duration of the same magnitude' do
        expect(duration.abs).to eq described_class.new(1)
      end
    end

    context 'when the duration is positive' do
      let(:duration) { described_class.new(1) }

      it 'returns an equivalent duration' do
        expect(duration.abs).to eq duration
      end
    end
  end

  context 'when performing comparison' do
    context 'and the compared object does not respond to #to_i' do
      it 'raises an argument error' do
        expect { duration < Object.new }.to raise_error ArgumentError
      end
    end

    context 'and the compared object responds to #to_i' do
      it 'compares as expected' do
        expect(duration > 1).to eq true
      end
    end

    context 'and the comparing object is an integer' do
      it 'compares as expected' do
        expect(1 < duration).to eq true
      end
    end
  end
end
