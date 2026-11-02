require "rails_helper"

# Client content PDFs (Nov 2026): treatment and technology sub-pages are built
# from dashboard-editable "page sections" (DetailBlocks on Treatment/Device).
RSpec.describe "Detail pages (treatments / technologies)", type: :request do
  def fill(record, values)
    record.ensure_blocks!
    values.each do |key, (ar, en)|
      row = record.contents.detect { |c| c.key == key.to_s }
      row.update!(value_ar: ar, value_en: en)
    end
  end

  describe "treatment sub-page" do
    let!(:treatment) { Treatment.create!(slug: "skin", title_en: "Tired skin", headline_en: "Bring back the glow", look_en: "Dull and tired.", position: 1) }

    it "keeps the legacy layout while no section is filled for the locale" do
      get "/treatments/skin"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("over-hero--outcome")
      expect(response.body).not_to include("dp-hero")
    end

    it "renders the editable sections, CTA bands and FAQ once filled" do
      fill(treatment, hero_title: [ "علاجات البشرة في الرياض", nil ],
                      hero_intro: [ "كل بشرة لها احتياجاتها الخاصة.", nil ],
                      s1_title: [ "ما أسباب بهتان البشرة؟", nil ],
                      s1_items: [ "نقص الترطيب: قد يؤدي إلى الجفاف.\nالتعرض للشمس: دون حماية.", nil ],
                      s2_title: [ "كيف تختار نيوسكن العلاج؟", nil ],
                      s2_items: [ "تقييم حالة البشرة: تحديد طبيعتها.", nil ],
                      faq_1_q: [ "متى تظهر النتائج؟", nil ],
                      faq_1_a: [ "يختلف التوقيت بحسب الحالة.", nil ])
      get "/ar/treatments/skin"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('class="dp-hero"')
      expect(response.body).to include("<h1 data-reveal=\"up\">علاجات البشرة في الرياض</h1>")
      expect(response.body).not_to include('class="clinic-hero-eyebrow')       # card tag is no longer a hero eyebrow
      expect(response.body).to include("<h2>ما أسباب بهتان البشرة؟</h2>")
      expect(response.body).to include("<b>نقص الترطيب</b> قد يؤدي إلى الجفاف.")
      expect(response.body.scan('<ul class="dp-list').size).to eq(1)
      expect(response.body).to include('<ol class="clinic-points dp-steps')
      expect(response.body.scan('class="cta-center cta-center--tight orn-host dp-cta"').size).to eq(2)
      expect(response.body).to include("<h2>الأسئلة الشائعة</h2>")
      expect(response.body).to include("<h3 class=\"dp-sub\">كل ما تحتاجين معرفته قبل الحجز</h3>")
      expect(response.body).to include("<span>متى تظهر النتائج؟</span>")
      expect(response.body).not_to include("over-hero--outcome")
      # English stays on the legacy layout: nothing was filled for it
      get "/treatments/skin"
      expect(response.body).to include("over-hero--outcome")
    end
  end

  describe "technology sub-page" do
    let!(:device) { Device.create!(name: "EMTONE", tagline_en: "Harmonious", body_en: "Card copy.", position: 1) }
    let!(:other)  { Device.create!(name: "EMFACE", position: 2) }

    it "renders hero eyebrow, what-it-is split, cards, steps and FAQ when filled" do
      fill(device, hero_eyebrow: [ "تقنية EMTONE", nil ], hero_title: [ "تقنية EMTONE لتحسين مظهر السيلوليت", nil ],
                   what_title: [ "ما هي تقنية EMTONE؟", nil ], what_body: [ "إجراء غير جراحي.", nil ],
                   how_title: [ "كيف تعمل؟", nil ], how_items: [ "الطاقة الحرارية: تسخين الأنسجة.\nطاقة الضغط: نبضات ميكانيكية.", nil ],
                   steps_title: [ "خطوات الجلسة", nil ], steps_items: [ "التقييم الطبي: مناقشة أهدافكِ.", nil ],
                   faq_1_q: [ "هل الجلسات مؤلمة؟", nil ], faq_1_a: [ "قد يشعر الشخص بالدفء.", nil ])
      get "/ar/technologies/emtone"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('<span class="eyebrow reveal" data-reveal-target="item">تقنية EMTONE</span>')
      expect(response.body).to include("<h1 data-reveal=\"up\">تقنية EMTONE لتحسين مظهر السيلوليت</h1>")
      expect(response.body).to include('<h2 class="dp-h2">ما هي تقنية EMTONE؟</h2>')
      expect(response.body.scan('<div class="dp-card">').size).to eq(2)
      expect(response.body).to include('<ol class="clinic-points dp-steps')
      expect(response.body).to include("<span>هل الجلسات مؤلمة؟</span>")
      expect(response.body).to include('class="device-others"')               # related strip still renders
      get "/technologies/emtone"
      expect(response.body).to include("over-hero--device")
    end
  end

  describe "admin editing" do
    let(:admin) { User.create!(email: "ed@neuskin.test", password: "changeme123", role: "admin") }
    let!(:device) { Device.create!(name: "EMFACE") }
    before { sign_in admin }

    it "shows the page-section fields and saves them" do
      get edit_admin_device_path(device)
      expect(response.body).to include("Page sections")
      expect(response.body).to include("Session steps — numbered steps")
      row = device.reload.contents.detect { |c| c.key == "hero_title" }
      patch admin_device_path(device), params: { device: { name: "EMFACE",
        contents_attributes: { "0" => { id: row.id, key: "hero_title", value_ar: "جهاز EMFACE لشد البشرة", value_en: "" } } } }
      expect(device.reload.contents.detect { |c| c.key == "hero_title" }.value_ar).to eq("جهاز EMFACE لشد البشرة")
    end

    it "shows the fields on the new-treatment form too" do
      get new_admin_treatment_path
      expect(response.body).to include("Section 1 — the causes")
    end
  end

  describe "content seed round-trip" do
    it "imports detail_pages.json into existing records and exports it back" do
      Dir.mktmpdir do |dir|
        Treatment.create!(slug: "body", title_en: "Body", headline_en: "Sculpt", position: 1)
        File.write(File.join(dir, "content.json"), "[]")
        File.write(File.join(dir, ContentSeed::DETAIL_FILE), { "treatments" => { "body" => { "hero_title" => { "ar" => "نحت الجسم" } }, "missing" => { "hero_title" => { "ar" => "x" } } } }.to_json)
        ContentSeed.import(Pathname.new(dir))
        expect(Treatment.find_by!(slug: "body").block("hero_title")).to eq("")  # English locale
        I18n.with_locale(:ar) { expect(Treatment.find_by!(slug: "body").block("hero_title")).to eq("نحت الجسم") }
        ContentSeed.export(Pathname.new(dir))
        data = JSON.parse(File.read(File.join(dir, ContentSeed::DETAIL_FILE)))
        expect(data.dig("treatments", "body", "hero_title", "ar")).to eq("نحت الجسم")
      end
    end
  end
end
