RSpec.describe Biz::TimeSegment do
  let(:start_time) { Time.utc(2006, 1, 8, 9, 30) }
  let(:end_time)   { Time.utc(2006, 1, 22, 17) }

  subject(:time_segment) { described_class.new(start_time, end_time) }

  describe '.before' do
    it 'returns the time segment before the provided time' do
      expect(described_class.before(start_time)).to eq(
        described_class.new(Biz::Time::BIG_BANG, start_time)
      )
    end
  end

  describe '.after' do
    it 'returns the time segment after the provided time' do
      expect(described_class.after(start_time)).to eq(
        described_class.new(start_time, Biz::Time::HEAT_DEATH)
      )
    end
  end

  describe '#duration' do
    it 'returns the duration of the time segment in seconds' do
      expect(time_segment.duration).to eq((end_time - start_time).to_i)
    end
  end

  describe '#empty?' do
    context 'when the start time equals the end time' do
      let(:time_segment) { described_class.new(start_time, start_time) }

      it 'returns true' do
        expect(time_segment.empty?).to eq true
      end
    end

    context 'when the start time does not equal the end time' do
      let(:time_segment) { described_class.new(start_time, end_time) }

      it 'returns false' do
        expect(time_segment.empty?).to eq false
      end
    end
  end

  describe '#&' do
    let(:other) { described_class.new(other_start_time, other_end_time) }

    context 'when the other segment occurs before the time segment' do
      let(:other_start_time) { Time.utc(2006, 1, 1) }
      let(:other_end_time)   { Time.utc(2006, 1, 2) }

      it 'returns a zero-duration time segment' do
        expect(time_segment & other).to eq(
          described_class.new(start_time, start_time)
        )
      end
    end

    context 'when the other segment starts before the time segment' do
      let(:other_start_time) { Time.utc(2006, 1, 7) }

      context 'and ends before the time segment' do
        let(:other_end_time) { Time.utc(2006, 1, 8, 11, 45) }

        it 'returns the correct time segment' do
          expect(time_segment & other).to eq(
            described_class.new(start_time, other_end_time)
          )
        end
      end

      context 'and ends after the time segment' do
        let(:other_end_time) { Time.utc(2006, 1, 23) }

        it 'returns the correct time segment' do
          expect(time_segment & other).to eq(
            described_class.new(start_time, end_time)
          )
        end
      end
    end

    context 'when the other segment starts after the time segment' do
      let(:other_start_time) { Time.utc(2006, 1, 8, 11, 30) }

      context 'and ends before the time segment' do
        let(:other_end_time) { Time.utc(2006, 1, 9, 12, 30) }

        it 'returns the correct time segment' do
          expect(time_segment & other).to eq(
            described_class.new(other_start_time, other_end_time)
          )
        end
      end

      context 'and ends after the time segment' do
        let(:other_end_time) { Time.utc(2006, 1, 23) }

        it 'returns the correct time segment' do
          expect(time_segment & other).to eq(
            described_class.new(other_start_time, end_time)
          )
        end
      end
    end

    context 'when the other segment occurs after the time segment' do
      let(:other_start_time) { Time.utc(2006, 2, 1) }
      let(:other_end_time)   { Time.utc(2006, 2, 7) }

      it 'returns a zero-duration time segment' do
        expect(time_segment & other).to eq(
          described_class.new(other_start_time, other_start_time)
        )
      end
    end
  end
end
