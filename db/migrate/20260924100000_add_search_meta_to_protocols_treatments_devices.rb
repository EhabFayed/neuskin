# Per-record <title> / meta description for the pages the dashboard manages
# (protocol, treatment outcome, device) — the same pair Blog already has, so
# editors control every indexable page's search snippet without a deploy.
class AddSearchMetaToProtocolsTreatmentsDevices < ActiveRecord::Migration[8.0]
  def change
    %i[protocols treatments devices].each do |table|
      add_column table, :meta_title_en, :string
      add_column table, :meta_title_ar, :string
      add_column table, :meta_description_en, :text
      add_column table, :meta_description_ar, :text
    end
  end
end
