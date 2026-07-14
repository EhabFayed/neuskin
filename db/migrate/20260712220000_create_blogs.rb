# Journal posts — mirrors the top_brand blog data design (paired _ar/_en
# columns, slug, is_published, category, SEO meta, cover image via
# ActiveStorage) adapted to this app: paragraph blocks reuse the polymorphic
# Content model (like Section) instead of a separate blog_contents table.
class CreateBlogs < ActiveRecord::Migration[8.0]
  def change
    create_table :blogs do |t|
      t.string  :slug_en
      t.string  :slug_ar
      t.string  :title_ar
      t.string  :title_en
      t.text    :excerpt_ar
      t.text    :excerpt_en
      t.string  :meta_title_ar
      t.string  :meta_title_en
      t.text    :meta_description_ar
      t.text    :meta_description_en
      t.string  :alt_ar
      t.string  :alt_en
      t.string  :category
      t.boolean :is_published, default: false

      t.timestamps
    end
    add_index :blogs, :slug_ar, unique: true
    add_index :blogs, :slug_en, unique: true
    add_index :blogs, :is_published
  end
end
