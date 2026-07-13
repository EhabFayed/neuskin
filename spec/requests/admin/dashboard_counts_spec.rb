require "rails_helper"

RSpec.describe "Dashboard overview counts", type: :request do
  before { sign_in create(:user) }

  # Each tile is "<eyebrow>…<div class='n'>N</div>" — pin the pair so two
  # tiles sharing a number can't mask a wrong source.
  def tile(body, eyebrow)
    body[/#{eyebrow}<\/div>\s*<div class="n">(\d+)<\/div>/m, 1].to_i
  end

  it "renders the live count for every content type and moves with the data" do
    Inquiry.create!(name: "A", mobile: "+966512345678")
    BridalLead.create!(email: "bride@example.com")
    2.times { |i| Blog.create!(title_en: "P#{i}", title_ar: "ع#{i}", is_published: i.zero?) }
    3.times { |i| TeamMember.create!(name_en: "M#{i}", name_ar: "ع#{i}", position: i) }
    Faq.create!(question_en: "Q?", question_ar: "س؟", answer_en: "A.", answer_ar: "ج.")
    Story.create!(quote_en: "Quote.", quote_ar: "اقتباس.")
    Protocol.create!(slug: "p-one", name_en: "One", name_ar: "واحد")

    get "/admin"
    expect(tile(response.body, "Inbox")).to    eq(1)
    expect(tile(response.body, "Bridal")).to   eq(1)
    expect(tile(response.body, "Journal")).to  eq(2)
    expect(tile(response.body, "Team")).to     eq(3)
    expect(tile(response.body, "FAQ")).to      eq(1)
    expect(tile(response.body, "Stories")).to  eq(1)
    expect(tile(response.body, "Care")).to     eq(1)
    expect(tile(response.body, "Content")).to  eq(Section.count)
    expect(response.body).to include("1 draft")                     # journal drafts sub-label
    expect(response.body).to include("1 inquiry in the last 7 days.")

    # counts move with the data — no caching, no stale numbers
    Inquiry.create!(name: "B", mobile: "+966512345679")
    TeamMember.create!(name_en: "M9", name_ar: "ع٩", position: 9)
    get "/admin"
    expect(tile(response.body, "Inbox")).to eq(2)
    expect(tile(response.body, "Team")).to  eq(4)
    expect(response.body).to include("2 inquiries in the last 7 days.")
  end

  it "renders zeros cleanly on an empty database" do
    get "/admin"
    expect(tile(response.body, "Inbox")).to   eq(0)
    expect(tile(response.body, "Journal")).to eq(0)
    expect(response.body).to include("Nothing needs your attention right now.")
  end
end
