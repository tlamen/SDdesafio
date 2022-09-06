# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validating user' do
    context 'when using standard factory' do
      it { expect(build(:user)).to be_valid }
    end

    context 'when user email is nil' do
      it { expect(build(:user, email: nil)).to be_invalid }
    end

    context 'when user email is not valid' do
      it { expect(build(:user, email: 'emailsemarroba.com')).to be_invalid }
    end

    context 'when user password is nil' do
      it { expect(build(:user, password: nil)).to be_invalid }
    end

    context 'when user password is too short' do
      it { expect(build(:user, password: '12345')).to be_invalid }
    end

    context 'when user name is nil' do
      it { expect(build(:user, name: nil)).to be_invalid }
    end

    context 'when user birthdate is nil' do
      it { expect(build(:user, birthdate: nil)).to be_invalid }
    end

    context 'when user birthdate is invalid' do
      it { expect(build(:user, birthdate: Date.today)).to be_invalid }
    end
  end

  context 'validating user role' do
    context 'when user role is admin' do
      it { expect(build(:user, role: 1)).to be_valid }
    end

    context 'when user role is teacher' do
      it { expect(build(:user, role: 2)).to be_valid }
    end

    context 'when user role is client' do
      it { expect(build(:user, role: 3)).to be_valid }
    end

    context 'when user role is nil' do
      it { expect(build(:user, role: nil)).to be_invalid }
    end

    context 'when user role is invalid' do
      it { expect(build(:user, role: 4)).to be_invalid }
    end

    context 'when user role is 0' do
      it { expect(build(:user, role: 0)).to be_invalid }
    end

    context 'when user role is negative' do
      it { expect(build(:user, role: -1)).to be_invalid }
    end
  end
end
