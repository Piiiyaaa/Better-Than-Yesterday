require 'rails_helper'

RSpec.describe User, type: :model do
    describe 'バリデーションチェック' do
        it '設定したすべてのバリデーションが機能しているか' do
            user = build(:user)
            expect(user).to be_valid
        end
    end
end
