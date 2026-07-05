require "rails_helper"

RSpec.describe Section, type: :model do
  it "requires page and kind" do
    s = Section.new
    expect(s).not_to be_valid
    expect(s.errors[:page]).to be_present
    expect(s.errors[:kind]).to be_present
  end

  it "enforces one kind per page" do
    create(:section, page: "home", kind: "home_hero")
    dup = build(:section, page: "home", kind: "home_hero")
    expect(dup).not_to be_valid
  end

  it "allows the same kind on a different page" do
    create(:section, page: "home", kind: "hero")
    expect(build(:section, page: "dr_maysa", kind: "hero")).to be_valid
  end

  describe ".for" do
    it "returns the matching section" do
      s = create(:section, page: "home", kind: "home_hero")
      expect(Section.for("home", "home_hero")).to eq(s)
    end

    it "returns a blank unsaved section when none exists" do
      result = Section.for("home", "missing")
      expect(result).to be_a(Section)
      expect(result).to be_new_record
      expect(result.contents).to be_empty
      expect(result.items).to eq([])
    end
  end
end
