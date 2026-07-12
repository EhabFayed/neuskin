# Bilingual alt text for a Content block's attached photo (journal paragraph
# images — top_brand's blog_con_photos alt_ar/alt_en, folded into Content).
class AddAltToContents < ActiveRecord::Migration[8.0]
  def change
    add_column :contents, :alt_ar, :string
    add_column :contents, :alt_en, :string
  end
end
