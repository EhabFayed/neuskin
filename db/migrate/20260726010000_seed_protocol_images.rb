# Data migration: attach the content team's protocol photos (July 26, 2026
# batch, committed under db/seed_data/protocols as <slug>.jpg) to the six
# protocols. These drive the home "Six protocols" stage, the hub cards, and
# each protocol page hero (see ContentHelper#protocol_image_url).
#
# Idempotent: attaches only when the protocol has no image yet, so dashboard
# uploads are never clobbered — the same pattern as the device card photos.
class SeedProtocolImages < ActiveRecord::Migration[8.0]
  def up
    images_dir = Rails.root.join("db/seed_data/protocols")
    return unless File.directory?(images_dir)

    attached = 0
    Protocol.find_each do |protocol|
      next if protocol.image.attached?

      path = images_dir.join("#{protocol.slug}.jpg")
      next unless File.exist?(path)

      protocol.image.attach(io: File.open(path),
                            filename: "#{protocol.slug}.jpg",
                            content_type: "image/jpeg")
      attached += 1
    end
    say "Protocol images attached: #{attached}/#{Protocol.count}"
  end

  def down
    # Content is data, not schema — nothing to reverse.
  end
end
