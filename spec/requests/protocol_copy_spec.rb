require "rails_helper"

# Protocol page copy that used to be fixed locale strings is now editable:
# the "who it's for" signs per protocol (Admin → Protocols) and the shared
# template lines (Pages → Protocol page). Blank values keep the old copy.
RSpec.describe "Protocol page editable copy", type: :request do
  let!(:protocol) do
    Protocol.create!(slug: "neuskin-method", position: 1,
                     name_en: "The NeuSkin Method", name_ar: "منهج نيوسكن",
                     who_for_en: "For anyone beginning with us.", who_for_ar: "لكل من تبدأ رحلتها معنا.")
  end

  describe "who it's for signs" do
    it "shows the standard three signs when the protocol has none of its own" do
      get "/protocols/neuskin-method"
      expect(response.body).to include("measured, not guessed")
      get "/ar/protocols/neuskin-method"
      expect(response.body).to include("بالقياس، لا بالتخمين")
    end

    it "shows the protocol's own signs, one per line, per language" do
      protocol.update!(signs_en: "First sign.\nSecond sign.\n\n", signs_ar: "العلامة الأولى.\nالعلامة الثانية.")
      get "/protocols/neuskin-method"
      expect(response.body).to include("First sign.").and include("Second sign.")
      expect(response.body).not_to include("measured, not guessed")
      expect(response.body.scan('class="n"').size).to eq(2)
      get "/ar/protocols/neuskin-method"
      expect(response.body).to include("العلامة الأولى.")
    end

    it "falls back to the English signs on the Arabic page when Arabic is blank" do
      protocol.update!(signs_en: "Only English.", signs_ar: "")
      get "/ar/protocols/neuskin-method"
      expect(response.body).to include("Only English.")
    end

    it "starts a new protocol with the standard three lines in the field" do
      sign_in User.create!(email: "ed0@neuskin.test", password: "changeme123", role: "admin")
      get "/admin/protocols/new"
      expect(response.body).to include("measured, not guessed")
      expect(response.body).to include("بالقياس، لا بالتخمين")
    end

    it "is saved from the protocol form" do
      sign_in User.create!(email: "ed@neuskin.test", password: "changeme123", role: "admin")
      patch "/admin/protocols/neuskin-method", params: { protocol: { signs_en: "A\nB\nC", signs_ar: "أ\nب\nج" } }
      expect(protocol.reload.signs_en).to eq("A\nB\nC")
      get "/admin/protocols/neuskin-method/edit"
      expect(response.body).to include("one per line")
      expect(response.body).to include("A\nB\nC")
    end
  end

  describe "timeline stages, FAQ and story from the form" do
    let(:admin) { User.create!(email: "rows@neuskin.test", password: "changeme123", role: "admin") }
    before { sign_in admin }

    it "shows the existing stages and the add button on the edit form" do
      protocol.update!(stages: [ { "week_en" => "Weeks 1–4", "week_ar" => "الأسابيع ١–٤", "title_en" => "Prepare", "title_ar" => "التهيئة", "body_en" => "Deep cleansing.", "body_ar" => "تنظيف عميق." } ])
      get "/admin/protocols/neuskin-method/edit"
      expect(response.body).to include("Weeks 1–4").and include("التهيئة").and include("Add stage").and include("Add reason")
      expect(response.body).to include('data-controller="rows"')
    end

    it "saves stages in Order, dropping removed and blank rows" do
      patch "/admin/protocols/neuskin-method", params: { protocol: { stages_form: "1", stages: {
        "0" => { position: "2", week_en: "Weeks 5–8", week_ar: "٥–٨", title_en: "Treat", title_ar: "العلاج", body_en: "Sessions.", body_ar: "جلسات." },
        "1" => { position: "1", week_en: "Weeks 1–4", week_ar: "١–٤", title_en: "Prepare", title_ar: "التهيئة", body_en: "Cleansing.", body_ar: "تنظيف." },
        "2" => { position: "3", week_en: "Gone", title_en: "Gone", _destroy: "1" },
        "3" => { position: "4", week_en: "", title_en: "  ", body_en: "" }
      } } }
      stages = protocol.reload.stages
      expect(stages.map { |s| s["title_en"] }).to eq([ "Prepare", "Treat" ])
      expect(stages.first.keys).to match_array(%w[week_en week_ar title_en title_ar body_en body_ar])
      get "/protocols/neuskin-method"
      expect(response.body).to include("Weeks 1–4").and include("Sessions.")
    end

    it "saves the patient story and clears it when emptied" do
      patch "/admin/protocols/neuskin-method", params: { protocol: {
        story_form: "1", patient_story: { quote_en: "Worth it.", quote_ar: "يستحق.", initials: "L.M.", year: "2026" } } }
      protocol.reload
      expect(protocol.patient_story).to eq({ "quote_en" => "Worth it.", "quote_ar" => "يستحق.", "initials" => "L.M.", "year" => "2026" })
      get "/protocols/neuskin-method"
      expect(response.body).to include("Worth it.")

      patch "/admin/protocols/neuskin-method", params: { protocol: { story_form: "1", patient_story: { quote_en: "", quote_ar: "", initials: "", year: "" } } }
      expect(protocol.reload.patient_story).to eq({})
    end

    it "leaves the structured data alone when its form block was not submitted" do
      protocol.update!(stages: [ { "week_en" => "W1", "title_en" => "Keep" } ])
      patch "/admin/protocols/neuskin-method", params: { protocol: { promise_en: "New promise." } }
      expect(protocol.reload.stages.first["title_en"]).to eq("Keep")
    end
  end

  describe "hero rows" do
    it "shows the original three rows when the list is empty and the list when set, with add/remove on the form" do
      get "/ar/protocols/neuskin-method"
      expect(response.body).to include('<span class="k">المدّة</span>')

      protocol.update!(specs: [ { "label_en" => "Duration", "label_ar" => "المدّة", "value_en" => "1 session", "value_ar" => "جلسة واحدة" },
                                { "label_en" => "Sessions", "label_ar" => "الجلسات", "value_en" => "Up to 4", "value_ar" => "حتى ٤" } ])
      get "/ar/protocols/neuskin-method"
      expect(response.body).to include('<span class="k">الجلسات</span><span class="v">حتى ٤</span>')
      expect(response.body).not_to include('<span class="k">الصيغة</span>')

      sign_in User.create!(email: "rows2@neuskin.test", password: "changeme123", role: "admin")
      get "/admin/protocols/neuskin-method/edit"
      expect(response.body).to include("Hero rows").and include("Add row").and include("حتى ٤")
      patch "/admin/protocols/neuskin-method", params: { protocol: { specs_form: "1", specs: {
        "0" => { position: "1", label_en: "Duration", label_ar: "المدّة", value_en: "1 session", value_ar: "جلسة واحدة" },
        "1" => { position: "2", label_en: "Sessions", label_ar: "الجلسات", value_en: "Up to 4", value_ar: "حتى ٤", _destroy: "1" },
        "2" => { position: "3", label_en: "Where", label_ar: "أين", value_en: "Riyadh", value_ar: "الرياض" } } } }
      expect(protocol.reload.specs.map { |r| r["label_en"] }).to eq([ "Duration", "Where" ])
    end
  end

  describe "why choose block" do
    it "is hidden without points and renders the heading + numbered reasons with bold labels when set" do
      get "/ar/protocols/neuskin-method"
      expect(response.body).not_to include("proto-why")

      protocol.update!(why_title_ar: "لماذا تختارين منهج نيو سكين؟", why_title_en: "Why choose the NeuSkin Method?",
                       why_points: [ { "text_ar" => "تقييم متخصص: لفهم حالة بشرتك.", "text_en" => "Expert assessment: a precise understanding." },
                                     { "text_ar" => "جملة بلا عنوان.", "text_en" => "A plain sentence." } ])
      get "/ar/protocols/neuskin-method"
      expect(response.body).to include('<h2 class="proto-why-title">لماذا تختارين منهج نيو سكين؟</h2>')
      expect(response.body).to include("<strong>تقييم متخصص</strong>: لفهم حالة بشرتك.")
      expect(response.body).to include("جملة بلا عنوان.")
      expect(response.body.scan("proto-why").size).to be >= 1
      get "/protocols/neuskin-method"
      expect(response.body).to include("Why choose the NeuSkin Method?").and include("<strong>Expert assessment</strong>")
    end

    it "is edited from the protocol form" do
      sign_in User.create!(email: "why@neuskin.test", password: "changeme123", role: "admin")
      patch "/admin/protocols/neuskin-method", params: { protocol: { why_title_en: "Why us?", why_title_ar: "لماذا نحن؟",
        why_points_form: "1", why_points: { "0" => { text_en: "One.", text_ar: "واحد." }, "1" => { text_en: "", text_ar: "" } } } }
      protocol.reload
      expect(protocol.why_title_ar).to eq("لماذا نحن؟")
      expect(protocol.why_points).to eq([ { "text_en" => "One.", "text_ar" => "واحد." } ])
      get "/admin/protocols/neuskin-method/edit"
      expect(response.body).to include("Add reason").and include("لماذا نحن؟")
    end
  end

  describe "FAQ placed on the protocol page" do
    def make_faq(attrs = {})
      Faq.create!({ question_en: "Does the first session include treatments?", question_ar: "هل الجلسة الأولى تشمل علاجات؟",
                    answer_en: "No, it is an assessment.", answer_ar: "لا، هي جلسة تقييم.",
                    category: "how_care_works", position: 1 }.merge(attrs))
    end

    it "hides the block without placed questions and shows h2, h3 and the questions when placed" do
      make_faq(on_faq_page: true)
      get "/ar/protocols/neuskin-method"
      expect(response.body).not_to include("proto-faq")

      make_faq(question_en: "How long is it?", question_ar: "كم تستغرق؟", on_faq_page: false, placements: [ "protocol:neuskin-method" ], position: 2)
      get "/ar/protocols/neuskin-method"
      expect(response.body).to include("<h2>الأسئلة الشائعة</h2>")
      expect(response.body).to include('<h3 class="proto-faq-sub">كل ما تحتاجين معرفته قبل الحجز</h3>')
      expect(response.body).to include("كم تستغرق؟").and include("لا، هي جلسة تقييم.")
      expect(response.body).not_to include("هل الجلسة الأولى تشمل علاجات؟")
    end

    it "keeps a question off the /faq page when its switch is off, and shows it there when on" do
      make_faq(question_en: "Placed only", question_ar: "مُدرج فقط", on_faq_page: false, placements: [ "protocol:neuskin-method" ])
      make_faq(question_en: "Both places", question_ar: "في المكانين", on_faq_page: true, placements: [ "protocol:neuskin-method" ], position: 2)
      get "/faq"
      expect(response.body).to include("Both places")
      expect(response.body).not_to include("Placed only")
      get "/protocols/neuskin-method"
      expect(response.body).to include("Placed only").and include("Both places")
    end

    it "is placed from the FAQ form and listed on the protocol form" do
      sign_in User.create!(email: "faq@neuskin.test", password: "changeme123", role: "admin")
      faq = make_faq
      patch "/admin/faqs/#{faq.id}", params: { faq: { on_faq_page: "0", placements: [ "", "protocol:neuskin-method" ] } }
      faq.reload
      expect(faq.on_faq_page).to be(false)
      expect(faq.placements).to eq([ "protocol:neuskin-method" ])
      get "/admin/faqs/#{faq.id}/edit"
      expect(response.body).to include("Where it shows").and include("Protocol · The NeuSkin Method")
      get "/admin/protocols/neuskin-method/edit"
      expect(response.body).to include("Does the first session include treatments?")
    end
  end

  describe "shared template copy" do
    it "renders the locale lines when the section has no content" do
      get "/protocols/neuskin-method"
      expect(response.body).to include("This protocol is not for everyone")
      expect(response.body).to include("Honesty, set early.")
      expect(response.body).to include("Doctor-led · personalised")
      expect(response.body).to include("Sessions, reviewed each quarter.")
    end

    it "renders the dashboard values when set" do
      section = Section.create!(page: "protocol", kind: "template", label: "Shared")
      section.contents.create!(key: "not_for_all", value_en: "Not for everyone, on purpose.", value_ar: "ليس للجميع، عن قصد.")
      section.contents.create!(key: "honesty", value_en: "Straight talk.", value_ar: "كلام صريح.")
      section.contents.create!(key: "journey_4_body", value_en: "Reviewed every season.", value_ar: "تُراجَع كل موسم.")
      get "/protocols/neuskin-method"
      expect(response.body).to include("Not for everyone, on purpose.")
      expect(response.body).to include("Straight talk.")
      expect(response.body).to include("Reviewed every season.")
      expect(response.body).not_to include("Honesty, set early.")
      get "/ar/protocols/neuskin-method"
      expect(response.body).to include("كلام صريح.")
    end

    it "is listed under Pages and previews against a real protocol" do
      sign_in User.create!(email: "ed2@neuskin.test", password: "changeme123", role: "admin")
      section = Section.create!(page: "protocol", kind: "template", label: "Shared")
      get "/admin/pages"
      expect(response.body).to include("Protocol page")
      get "/admin/pages/protocol"
      expect(response.body).to include("Shared")
      get "/admin/sections/#{section.id}/preview", params: { section: { label: section.label } }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("The NeuSkin Method")
    end
  end
end
