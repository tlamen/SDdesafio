require 'rails_helper'

RSpec.describe Activity, type: :model do
  let(:teacher) { create(:user, id: 1) }
  let(:category) { create(:category, id: 1) }

  describe 'validating activity' do
    context 'when using standard factory' do
      it { expect(build(:activity)).to be_valid }
    end

    context 'when name is nil' do
      it { expect(build(:activity, name: '')).to be_invalid }
    end

    context 'when description is nil' do
      it { expect(build(:activity, description: '')).to be_invalid }
    end

    context 'when week_day is nil' do
      it { expect(build(:activity, week_day: '')).to be_invalid }
    end

    context 'when week_day is invalid' do
      it { expect(build(:activity, week_day: 'not a week day')).to be_invalid }
    end

    context 'when start_time is nil' do
      it { expect(build(:activity, start_time: '')).to be_invalid }
    end

    context 'when duration is nil' do
      it { expect(build(:activity, duration: nil)).to be_invalid}
    end

    context 'when duration is negative' do
      it { expect(build(:activity, duration: -5)).to be_invalid}
    end

    context 'when teacher is nil' do
      it { expect(build(:activity, user: nil)).to be_invalid}
    end

    context 'when category is nil' do
      it { expect(build(:activity, category: nil)).to be_invalid}
    end
  end
end
