require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'factory' do
    context 'when using standard factory' do
      it { expect(build(:category)).to be_valid }
    end
  end
end
