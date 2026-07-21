require "rails_helper"

RSpec.describe "Stories and protocol admin", type: :request do
  def make_story(attrs = {})
    Story.create!({
      intro_en: "A bride with six months.", intro_ar: "عروس أمامها ستة أشهر.",
      quote_en: "They promised me a calendar, and they kept it.",
      quote_ar: "وعدوني بجدولٍ زمني، والتزموا به.",
      byline_en: "A.R. · 29 · Jeddah", byline_ar: "أ.ر. · ٢٩ · جدة",
      position: 1
    }.merge(attrs))
  end

  describe "public stories page" do
    it "renders stories from the DB" do
      make_story
      get "/stories"
      expect(response.body).to include("They promised me a calendar")
    end

    it "renders Arabic under /ar" do
      make_story
      get "/ar/stories"
      expect(response.body).to include("وعدوني بجدولٍ زمني، والتزموا به.")
    end
  end

  describe "stories admin" do
    before { sign_in create(:user) }

    it "creates and deletes a story" do
      post "/admin/stories", params: { story: {
        quote_en: "New quote.", quote_ar: "اقتباس جديد.", position: 2
      } }
      story = Story.find_by(quote_en: "New quote.")
      expect(story).to be_present

      delete "/admin/stories/#{story.id}"
      expect(Story.exists?(story.id)).to be(false)
    end
  end

  describe "protocols admin" do
    let!(:protocol) do
      Protocol.create!(slug: "neuskin-method", position: 1, trademark: true,
                       name_en: "The NeuSkin Method", name_ar: "منهج نيوسكن",
                       promise_en: "Where every plan begins.", promise_ar: "حيث تبدأ كل خطة.")
    end

    before { sign_in create(:user) }

    it "lists the protocols" do
      get "/admin/protocols"
      expect(response.body).to include("The NeuSkin Method")
    end

    it "updates protocol copy" do
      patch "/admin/protocols/#{protocol.slug}", params: { protocol: {
        promise_en: "Updated promise line.", promise_ar: "سطر الوعد المحدَّث."
      } }
      expect(protocol.reload.promise_en).to eq("Updated promise line.")
      expect(response).to redirect_to("/admin/protocols")

      # the public protocols page reflects the edit
      get "/protocols"
      expect(response.body).to include("Updated promise line.")
    end

    it "creates a protocol with an auto-derived slug and a working public page" do
      post "/admin/protocols", params: { protocol: {
        name_en: "Post-Summer Repair", name_ar: "إصلاح ما بعد الصيف",
        promise_en: "Undo the season, gently.", promise_ar: "أصلحي أثر الموسم، برفق.",
        scope_en: "Repair in three steps.", scope_ar: "الإصلاح في ثلاث خطوات.",
        position: 7, persona: "tired"
      } }
      created = Protocol.find_by(name_en: "Post-Summer Repair")
      expect(created).to be_present
      expect(created.slug).to eq("post-summer-repair")

      # detail page renders without stages/faqs/story jsonb
      get "/protocols/post-summer-repair"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Post-Summer Repair")
    end

    it "deletes a protocol" do
      delete "/admin/protocols/#{protocol.slug}"
      expect(Protocol.exists?(protocol.id)).to be(false)
    end
  end
end
