# Data migration: carry the July 2026 content work to environments that
# already ran the original SeedCmsContent import (i.e. production).
#
# 1. Re-imports db/content_seed/content.json — the Technologies page
#    sections + images, the About NeuSkin rewrite, and the site-wide Maysa
#    replacement inside CMS copy. (ContentSeed.import upserts text and only
#    attaches images into empty slots.)
# 2. Applies the Maysa replacement to record tables that content.json does
#    not cover: the protocol rename (maysa-method -> neuskin-method) and the
#    person-reference scrub in FAQ / blog records, plus removal of the
#    founder team-member entry.
#
# Idempotent: gsub maps simply find nothing on a clean database.
class SyncJulyContentAndMaysaReplacement < ActiveRecord::Migration[8.0]
  EN_MAP = [
    ["The Maysa Method™", "The NeuSkin Method™"],
    ["Maysa Method™", "NeuSkin Method™"],
    ["The Maysa Method", "The NeuSkin Method"],
    ["Maysa Method", "NeuSkin Method"],
    ["Will I see Dr. Maysa herself?", "Who will conduct my assessment?"],
    ["conducted personally by Dr. Maysa. Ongoing care may involve the wider medical team, always under her direction.",
     "conducted personally by our medical director. Ongoing care may involve the wider medical team, always under their direction."],
    ["Dr. Maysa or our patient relations lead reviews", "Our medical team or patient relations lead reviews"],
    ["patient relations lead and Dr. Maysa.", "patient relations lead and your treating doctor."],
    ["led by Dr. Maysa", "led by our medical director"],
    ["By Dr. Maysa, personally.", "By our medical director, personally."],
    ["A standing relationship with Dr. Maysa", "A standing relationship with your doctor"],
    ["signed by Dr. Maysa", "signed by our medical team"],
    ["— Dr. Maysa, Founder", "— The NeuSkin Team"],
    ["— Dr. Maysa", "— The NeuSkin Team"],
    ["Dr. Maysa Al-Rashid", "Medical Director"],
    ["begins and ends with Maysa. She reads the baseline, writes the plan, and signs off each quarterly review herself",
     "begins and ends with the medical director, who reads the baseline, writes the plan, and signs off each quarterly review"],
    ["Dr. Maysa", "our medical director"],
    ["— Maysa", "— The NeuSkin Team"],
    ["Maysa", "NeuSkin"]
  ].freeze

  AR_MAP = [
    ["منهجية \"ميسا\"", "منهجية \"نيوسكن\""],
    ["منهج ميساء", "منهج نيوسكن"],
    ["— د. ميسا، المؤسِسة", "— فريق نيوسكن"],
    ["— د. ميساء", "— فريق نيوسكن"],
    ["— د. ميسا", "— فريق نيوسكن"],
    ["— ميسا", "— فريق نيوسكن"],
    ["هل سأقابل د. ميساء بنفسها؟", "من سيُجري تقييمي الأول؟"],
    ["تقييمك الأول تُجريه د. ميساء شخصيًا", "تقييمك الأول تُجريه مديرتنا الطبية شخصيًا"],
    ["تُراجع د. ميساء أو", "يُراجع فريقنا الطبي أو"],
    ["ود. ميساء", "وطبيبتك المعالجة"],
    ["بقيادة د. ميساء", "بقيادة مديرتنا الطبية"],
    ["كان أول ما فعلته د. ميساء", "كان أول ما فعلته الطبيبة"],
    ["د. ميساء الراشد", "المديرة الطبية"],
    ["د. ميساء", "فريقنا الطبي"],
    ["ميساء", "نيوسكن"],
    ["ميسا", "نيوسكن"]
  ].freeze

  def up
    # 1. CMS copy + images (Technologies page, About NeuSkin, scrubbed text).
    if File.exist?(Rails.root.join(ContentSeed::DEFAULT_DIR, "content.json"))
      stats = ContentSeed.import
      say "CMS content re-imported: #{stats[:sections]} sections, #{stats[:contents]} contents"
    end

    # 2. Protocol rename + record-table scrub.
    if (p = Protocol.find_by(slug: "maysa-method"))
      p.update_columns(slug: "neuskin-method", name_en: "The NeuSkin Method", name_ar: "The NeuSkin Method")
      say "Protocol renamed: maysa-method -> neuskin-method"
    end
    Treatment.where(protocol_slug: "maysa-method").update_all(protocol_slug: "neuskin-method")

    scrub_columns Protocol, %w[name_en name_ar promise_en promise_ar who_for_en who_for_ar
                               scope_en scope_ar excludes_en excludes_ar meta_en meta_ar]
    scrub_columns Treatment, %w[title_en title_ar headline_en headline_ar look_en look_ar
                                how_en how_ar view_en view_ar]
    scrub_columns Faq, %w[question_en question_ar answer_en answer_ar]
    scrub_columns Blog, %w[title_en title_ar excerpt_en excerpt_ar meta_title_en meta_title_ar
                           meta_description_en meta_description_ar alt_en alt_ar]

    if (m = TeamMember.find_by(name_en: "Dr. Maysa Al-Rashid"))
      m.destroy!
      say "Founder team-member entry removed"
    end
  end

  def down
    # Content is data, not schema — nothing to reverse.
  end

  private

  def scrub(str)
    return str if str.blank?
    out = str.dup
    EN_MAP.each { |from, to| out.gsub!(from, to) }
    AR_MAP.each { |from, to| out.gsub!(from, to) }
    out
  end

  def scrub_columns(model, columns)
    changed = 0
    model.find_each do |record|
      updates = {}
      columns.each do |col|
        v = scrub(record.send(col))
        updates[col] = v if v != record.send(col)
      end
      next if updates.empty?
      record.update_columns(updates)
      changed += 1
    end
    say "#{model.name}: #{changed} records scrubbed" if changed.positive?
  end
end
