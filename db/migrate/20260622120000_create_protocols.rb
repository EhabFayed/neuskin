class CreateProtocols < ActiveRecord::Migration[8.0]
  def change
    create_table :protocols do |t|
      t.string  :slug, null: false
      t.integer :position, null: false, default: 0
      t.boolean :trademark, null: false, default: false

      # Routing / tracking
      t.string :persona            # who it's for (enumerized)
      t.string :codeword           # WhatsApp tracked-link codeword

      # Bilingual fields (explicit _ar / _en — see DESIGN doc §2.6)
      t.string :name_ar
      t.string :name_en
      t.text   :promise_ar
      t.text   :promise_en
      t.string :duration_ar
      t.string :duration_en
      t.string :meta_ar           # grid card meta line, e.g. "12 weeks · Skin reset"
      t.string :meta_en
      t.text   :who_for_ar
      t.text   :who_for_en
      t.text   :scope_ar          # "what's inside" intro
      t.text   :scope_en
      t.text   :excludes_ar       # "what's not included"
      t.text   :excludes_en

      # Structured sub-content rendered only with the parent (JSONB)
      t.jsonb :stages,        null: false, default: []  # [{week_ar,week_en,title_ar,title_en,body_ar,body_en}]
      t.jsonb :faqs,          null: false, default: []  # [{q_ar,q_en,a_ar,a_en}]
      t.jsonb :patient_story, null: false, default: {}  # {quote_ar,quote_en,initials,year}

      t.timestamps
    end

    add_index :protocols, :slug, unique: true
    add_index :protocols, :position
  end
end
