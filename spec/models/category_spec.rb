# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'validating category' do
    context 'when using standard factory' do
      it { expect(build(:category)).to be_valid }
    end

    context 'when name is nil' do
      it { expect(build(:category, name: '')).to be_invalid }
    end

    context 'when description is nil' do
      it { expect(build(:category, description: '')).to be_invalid }
    end

    context 'when name has already been taken' do
      before do
        create(:category, name: 'nome')
      end
      it { expect(build(:category, name: 'nome')).to be_invalid }
    end
  end

  describe
end
