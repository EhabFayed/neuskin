# Maps each editable Section (page, kind) to the CURRENT static image(s) it
# renders, so `content:seed_images` can attach those files to the section —
# making every image DB-backed and editable without changing how the site
# looks. Keys reference ApplicationHelper::NS_IMAGES.
#
#   single: attaches one file to Section#image
#   gallery: attaches an ordered list to Section#gallery (has_many_attached)
module SeedImages
  SINGLE = {
    ["home", "home_hero"]        => :hero_clinic,
    ["home", "home_founder"]     => :portrait_natural,
    ["home", "home_cta"]         => :lounge,
    ["dr_maysa", "drmaysa_hero"] => :maysa_hero,
    ["the_clinic", "clinic_hero"] => :clinic_hero,
    ["private_care", "private_hero"] => :resort,
    ["bridal", "bridal_hero"]    => :bride_bouquet,
  }.freeze

  GALLERY = {
    ["home", "home_clinic"]       => %i[treatment_room lounge device_table diptyque interior_ext],
    ["dr_maysa", "drmaysa_clips"] => %i[doctor_coat consult beauty_eyes],
    ["the_clinic", "clinic_space"] => %i[clinic_shot_1 clinic_shot_2 clinic_shot_3 clinic_shot_4 clinic_shot_5],
  }.freeze
end
