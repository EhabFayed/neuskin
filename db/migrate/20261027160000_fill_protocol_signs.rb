# Pre-fill the "who it's for" signs on every protocol with the three lines the
# page has always shown, so the dashboard field holds the real text for the
# content team to edit instead of an empty box with a hidden fallback. Only
# blank fields are filled; anything an editor has typed is left alone.
class FillProtocolSigns < ActiveRecord::Migration[8.0]
  SIGNS_EN = [
    "You want to know what your skin actually needs — measured, not guessed.",
    "You'd rather follow one sequenced plan than collect single treatments.",
    "You value discretion, and a doctor who will tell you what to skip."
  ].join("\n").freeze

  SIGNS_AR = [
    "تريدين أن تعرفي ما تحتاجه بشرتكِ فعلًا — بالقياس، لا بالتخمين.",
    "تفضّلين خطةً واحدة متسلسلة على جمع علاجات متفرّقة.",
    "تقدّرين الخصوصية، وطبيبةً تقول لكِ ما الذي تتجاوزينه."
  ].join("\n").freeze

  def up
    en = Protocol.unscoped.where(signs_en: [ nil, "" ]).update_all(signs_en: SIGNS_EN)
    ar = Protocol.unscoped.where(signs_ar: [ nil, "" ]).update_all(signs_ar: SIGNS_AR)
    say "signs pre-filled on #{en} protocols (EN) / #{ar} (AR)"
  end

  def down
    # Leave the text in place — it is real content now.
  end
end
