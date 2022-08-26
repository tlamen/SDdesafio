require 'rails_helper'

RSpec.describe Course, type: :model do
  describe 'factory' do
    context 'when using standard factory' do
      it { expect(build(:course)).to be_valid }
    end
  end
end
