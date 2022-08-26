require 'rails_helper'

RSpec.describe Registration, type: :model do
  describe 'factory' do
    context 'when using standard factory' do
      it { expect(build(:registration)).to be_valid }
    end
  end
end
