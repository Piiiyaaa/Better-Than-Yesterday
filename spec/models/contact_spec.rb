require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe 'バリデーションチェック' do
    it '設定したすべてのバリデーションが機能しているか' do
      contact = build(:contact)
      expect(contact).to be_valid
    end

    it '名前がないときにバリデーションが機能してinvalidになるか' do
      contact_without_name = build(:contact, name: "")
      expect(contact_without_name).to be_invalid
      expect(contact_without_name.errors[:name]).not_to be_empty
    end

    it 'メールアドレスがないときにバリデーションが機能してinvalidになるか' do
      contact_without_email = build(:contact, email: "")
      expect(contact_without_email).to be_invalid
      expect(contact_without_email.errors[:email]).not_to be_empty
    end

    it '件名がないときにバリデーションが機能してinvalidになるか' do
      contact_without_subject = build(:contact, subject: "")
      expect(contact_without_subject).to be_invalid
      expect(contact_without_subject.errors[:subject]).not_to be_empty
    end

    it 'メッセージがないときにバリデーションが機能してinvalidになるか' do
      contact_without_message = build(:contact, message: "")
      expect(contact_without_message).to be_invalid
      expect(contact_without_message.errors[:message]).not_to be_empty
    end
  end
end
