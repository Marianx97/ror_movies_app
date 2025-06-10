require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  it { should validate_presence_of(:username) }
  it { should validate_length_of(:username).is_at_least(3).is_at_most(20) }
  it { should validate_presence_of(:email) }

  it "validates email format" do
    user = build(:user, email: "invalid")
    expect(user).to_not be_valid
    expect(user.errors[:email]).to include("is invalid")
  end

  it "validates strong password" do
    weak_user = build(:user, password: "password", password_confirmation: "password")
    expect(weak_user).to_not be_valid
    expect(weak_user.errors[:password].join).to match(/must include/)
  end

  it "is valid with a strong password" do
    user = build(:user, password: "StrongP@ssw0rd!", password_confirmation: "StrongP@ssw0rd!")
    expect(user).to be_valid
  end

  it "defaults isAdmin to false" do
    user = build(:user)
    expect(user.isAdmin).to be_falsey
  end

  it "allows isAdmin to be true" do
    admin = build(:user, :admin)
    expect(admin.isAdmin).to be_truthy
  end
end
