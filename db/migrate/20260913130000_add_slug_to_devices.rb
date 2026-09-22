# Each device now has its own page (/technologies/:slug) — client follow-up
# to the Sept 2026 audit ("every technology should open its own page").
class AddSlugToDevices < ActiveRecord::Migration[8.0]
  def up
    add_column :devices, :slug, :string
    device = Class.new(ActiveRecord::Base) { self.table_name = "devices" }
    taken = {}
    device.order(:position, :id).each do |d|
      base = d.name.to_s.parameterize.presence || "device-#{d.id}"
      slug = base
      slug = "#{base}-#{d.id}" if taken[slug]
      taken[slug] = true
      d.update_columns(slug: slug)
    end
    change_column_null :devices, :slug, false
    add_index :devices, :slug, unique: true
  end

  def down
    remove_index :devices, :slug
    remove_column :devices, :slug
  end
end
