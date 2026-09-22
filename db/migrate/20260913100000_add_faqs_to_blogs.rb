# Per-article FAQ accordion (client audit): [{q_ar,q_en,a_ar,a_en}], the same
# shape Protocol#faqs uses.
class AddFaqsToBlogs < ActiveRecord::Migration[8.0]
  def change
    add_column :blogs, :faqs, :jsonb, null: false, default: []
  end
end
