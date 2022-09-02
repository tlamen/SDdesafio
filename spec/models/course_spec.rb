require 'rails_helper'

RSpec.describe Course, type: :model do
  let(:category) { create(:category) }
  let(:teacher) { create(:user) }

  describe 'validating course' do
    context 'when using standard factory' do
      it { expect(build(:course, category_id: category.id, user_id: teacher.id)).to be_valid }
    end

    context 'when name is nil' do
      it { expect(build(:course, name: '').to be_invalid) }
    end

    context 'when description is nil' do
      it { expect(build(:course, description: '')).to be_invalid }
    end

    context 'when week_day is nil' do
      it { expect(build(:course, week_day: '')).to be_invalid }
    end

    context 'when week_day is invalid' do
      it { expect(build(:course, week_day: 'not a week day')).to be_invalid }
    end

    context 'when start_time is nil' do
      it { expect(build(:course, start_time: '')).to be_invalid }
    end

    context 'when duration is nil' do
      it { expect(build(:course, duration: nil)).to be_invalid}
    end

    context 'when duration is negative' do
      it { expect(build(:course, duration: -5)).to be_invalid}
    end

    context 'when teacher is nil' do
      it { expect(build(:course, user: nil)).to be_invalid}
    end

    context 'when category is nil' do
      it { expect(build(:course, category: nil)).to be_invalid}
    end
  end
end
