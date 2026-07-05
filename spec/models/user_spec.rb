require "rails_helper"

RSpec.describe User, type: :model do
  it "defaults to the editor role" do
    expect(build(:user).role).to eq("editor")
  end

  it "exposes an admin? predicate" do
    expect(build(:admin_user).admin?).to be(true)
    expect(build(:user).admin?).to be(false)
  end

  it "requires a valid email and password" do
    expect(build(:user, email: nil)).not_to be_valid
    expect(build(:user, password: nil)).not_to be_valid
  end
end
