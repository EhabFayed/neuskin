# FAQ entries as records (top_brand has a Faq model; here they were fixed
# q_1..9 section keys). Bilingual question/answer, grouped by category,
# ordered by position within the group.
class CreateFaqs < ActiveRecord::Migration[8.0]
  def change
    create_table :faqs do |t|
      t.string  :question_ar
      t.string  :question_en
      t.text    :answer_ar
      t.text    :answer_en
      t.string  :category, null: false, default: "before_you_come_in"
      t.integer :position, null: false, default: 0

      t.timestamps
    end
    add_index :faqs, [:category, :position]
  end
end
