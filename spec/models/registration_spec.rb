require 'rails_helper'

RSpec.describe Registration, type: :model do
  describe 'validating registration' do
    before { create(:user, id: 0) }
    before { create(:activity, id: 0) }

    context 'when using standard factory' do
      it { expect(build(:registration)).to be_valid }
    end

    context 'when registration is not linked to user' do
      it { expect(build(:registration, user_id: nil)).to be_invalid }
    end

    context 'when registration is not linked to course' do
      it { expect(build(:registration, course_id: nil)).to be_invalid }
    end
  end
end
