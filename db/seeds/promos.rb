# Digital gift cards — four sample gifts in the concept deck's voice, so the
# /promo envelope has something inside out of the box. Idempotent by code;
# never overwrites a promo an editor has already touched.
[
  { code: "GLOW30", position: 1, percent: 30, label_en: "Skin Boosters", label_ar: "سكين بوسترز",
    title_en: "A Gift of Care", title_ar: "هدية من العناية",
    description_en: "For someone special.", description_ar: "لشخصٍ مميّز." },
  { code: "GLOW25", position: 2, percent: 25, label_en: "Botox", label_ar: "بوتوكس",
    title_en: "A Moment of Glow", title_ar: "لحظة توهّج",
    description_en: "Chosen just for you.", description_ar: "اختيرت لكِ خصيصًا." },
  { code: "GLOW20", position: 3, percent: 20, label_en: "Fillers", label_ar: "فيلر",
    title_en: "A Little Luxury", title_ar: "لمسة من الفخامة",
    description_en: "Refined, never overdone.", description_ar: "ملامح مصقولة دون مبالغة." },
  { code: "GLOW15", position: 4, percent: 15, label_en: "Laser", label_ar: "ليزر",
    title_en: "A Fresh Start", title_ar: "بداية جديدة",
    description_en: "Clearer, smoother skin.", description_ar: "بشرة أنقى وأنعم." }
].each do |attrs|
  Promo.unscoped.find_or_create_by!(code: attrs[:code]) { |p| p.assign_attributes(attrs) }
end
