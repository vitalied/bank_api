require 'rails_helper'

describe ModelAuthentication, type: :model do
  let(:user) { build :user }

  before { allow(RequestStore.store).to receive(:[]).with(:current_user).and_return(user) }

  context 'current_user' do
    describe '.current_user' do
      subject { ApplicationRecord.current_user }

      it { is_expected.to eq(user) }
    end

    describe '#current_user' do
      subject { User.new.send(:current_user) }

      it { is_expected.to eq(user) }
    end
  end

  context 'current_user_id' do
    describe '.current_user_id' do
      subject { ApplicationRecord.current_user_id }

      it { is_expected.to eq(user.id) }
    end

    describe '#current_user_id' do
      subject { User.new.send(:current_user_id) }

      it { is_expected.to eq(user.id) }
    end
  end
end
