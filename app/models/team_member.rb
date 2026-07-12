# A member of the medical team (the_team page). Dynamic counterpart of the
# old fixed member_1..4 section keys — ported from top_brand's leadership
# team pattern (repeated bilingual entries + photo each).
class TeamMember < ApplicationRecord
  has_one_attached :photo

  validates :name_en, :name_ar, presence: true

  default_scope { order(:position) }

  # Locale-aware readers, mirroring Protocol (name -> name_ar / name_en).
  %i[name role cred focus bio].each do |attr|
    define_method(attr) do
      public_send("#{attr}_#{localized_suffix}")
    end
  end

  private

  def localized_suffix
    I18n.locale == :ar ? "ar" : "en"
  end
end
