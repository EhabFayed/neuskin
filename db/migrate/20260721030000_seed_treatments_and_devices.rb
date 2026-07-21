# Data migration: carry the Treatment outcomes and Device cards to every
# environment. Production's entrypoint runs db:prepare, which seeds only a
# BRAND-NEW database — these records were added after production first booted,
# so db/seeds/{treatments,devices}.rb never ran there and /treatments and
# /technologies rendered empty grids. Mirrors the SeedCmsContent pattern.
#
# Idempotent: both seed files upsert by natural key (slug / name), and device
# images (db/seed_data/devices) attach only when the slot is empty — dashboard
# edits and uploads on environments that already have data are never clobbered.
class SeedTreatmentsAndDevices < ActiveRecord::Migration[8.0]
  def up
    load Rails.root.join("db/seeds/treatments.rb")
    load Rails.root.join("db/seeds/devices.rb")
    say "Treatments: #{Treatment.count}, Devices: #{Device.count} " \
        "(#{Device.all.count { |d| d.front_image.attached? }} with images)"
  end

  def down
    # Content is data, not schema — nothing to reverse.
  end
end
