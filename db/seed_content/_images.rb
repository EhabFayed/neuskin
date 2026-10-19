# Maps each editable Section (page, kind) to the CURRENT static image(s) it
# renders, so `content:seed_images` can attach those files to the section —
# making every image DB-backed and editable without changing how the site
# looks. Keys reference ApplicationHelper::NS_IMAGES.
#
#   single: attaches one file to Section#image
#   gallery: attaches an ordered list to Section#gallery (has_many_attached)
module SeedImages
  SINGLE = {
    [ "home", "home_hero" ]        => :hero_clinic,
    [ "home", "home_founder" ]     => :founder_portrait,
    [ "home", "home_cta" ]         => :lounge,
    [ "dr_maysa", "drmaysa_hero" ] => :maysa_hero,
    [ "the_clinic", "clinic_hero" ] => :clinic_hero,
    [ "private_care", "private_hero" ] => :resort,
    [ "bridal", "bridal_hero" ]    => :bride_bouquet
  }.freeze

  GALLERY = {
    [ "home", "home_clinic" ]       => %i[treatment_room lounge device_table diptyque interior_ext],
    [ "dr_maysa", "drmaysa_clips" ] => %i[doctor_coat consult beauty_eyes]
  }.freeze

  # Photo albums (Section#photos — one SectionPhoto per image, each with its
  # own caption): ordered [image key, caption_en, caption_ar] triples.
  ALBUMS = {
    [ "the_clinic", "clinic_space" ] => [
      [ :clinic_shot_1, "The lounge",     "صالة الاستقبال" ],
      [ :clinic_shot_2, "In the detail",  "في التفاصيل" ],
      [ :clinic_shot_3, "Device room",    "غرفة الأجهزة" ],
      [ :clinic_shot_4, "Treatment room", "غرفة الإجراءات" ],
      [ :clinic_shot_5, "The entrance",   "المدخل" ]
    ]
  }.freeze
end
