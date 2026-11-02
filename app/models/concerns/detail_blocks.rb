# Dashboard-editable page sections for the detail pages (/treatments/<slug>,
# /technologies/<slug>) — client content PDFs, Nov 2026 ("تعديلات صفحات
# العلاجات" / "تعديلات صفحات التقنيات"). Every heading, paragraph, list and
# FAQ on those pages is a bilingual Content row (the same polymorphic model
# the Studio uses for Sections), keyed by a fixed registry the including
# model declares with `detail_groups`. Lists are one item per line; a line
# written as "Title: text" renders the title as a bold lead.
#
# A page switches to the new structure only when the current locale has a
# hero title or any section title filled in; otherwise the legacy layout
# (card copy) renders, so untranslated locales never show an empty page.
module DetailBlocks
  extend ActiveSupport::Concern

  FAQ_SLOTS = 6
  ITEMS_HINT = "One point per line. Start a line with “Title: ” to show a bold lead.".freeze

  included do
    has_many :contents, -> { order(:position) },
             as: :parentable, dependent: :destroy, inverse_of: :parentable
    accepts_nested_attributes_for :contents
  end

  class_methods do
    # groups: array of { key:, label:, fields: [[key, kind, label, hint], …] }
    def detail_groups(groups)
      const_set(:DETAIL_GROUPS, groups.freeze)
    end

    # [key, kind, label, hint] helpers shared by both registries.
    def list_section_fields(prefix, label, numbered: false, subtitle: false)
      fields = [ [ "#{prefix}_title", :text, "#{label} — heading (h2)", nil ] ]
      fields << [ "#{prefix}_subtitle", :text, "#{label} — line under the heading", nil ] if subtitle
      fields << [ "#{prefix}_intro", :textarea, "#{label} — intro paragraph (optional)", nil ]
      fields << [ "#{prefix}_items", :lines, "#{label} — #{numbered ? 'numbered steps' : 'points'}", ITEMS_HINT ]
      fields << [ "#{prefix}_outro", :textarea, "#{label} — closing paragraph (optional)", nil ]
      fields
    end

    def faq_fields
      (1..FAQ_SLOTS).flat_map do |i|
        [ [ "faq_#{i}_q", :text, "Question #{i}", nil ],
          [ "faq_#{i}_a", :textarea, "Answer #{i}", nil ] ]
      end
    end

    def detail_field_keys
      self::DETAIL_GROUPS.flat_map { |g| g[:fields].map(&:first) }
    end
  end

  # Locale-aware text for a block key; "" when absent or blank.
  def block(key)
    contents.detect { |c| c.key == key.to_s }&.value.to_s
  end

  # One item per non-blank line → { title:, body: }; "Title: text" splits on
  # the first colon when it comes early enough to be a lead-in, not a sentence.
  def block_items(key)
    block(key).split(/\r?\n/).map(&:strip).reject(&:blank?).map do |line|
      if (m = line.match(/\A([^:：]{2,70}?)\s*[:：]\s*(.+)\z/m))
        { title: m[1].strip, body: m[2].strip }
      else
        { title: nil, body: line }
      end
    end
  end

  # Filled FAQ pairs in slot order.
  def detail_faqs
    (1..FAQ_SLOTS).filter_map do |i|
      q = block("faq_#{i}_q")
      { q: q, a: block("faq_#{i}_a") } if q.present?
    end
  end

  # True when the current locale has content for the new page structure.
  def detail_blocks?
    return false unless contents.loaded? || contents.any?

    self.class::DETAIL_GROUPS.any? do |g|
      g[:fields].any? { |(key, _kind, _label, _hint)| key.end_with?("_title") && block(key).present? }
    end
  end

  # Creates (or refreshes labels of) every registry row so the dashboard form
  # shows all fields. Builds in memory for unsaved records, persists otherwise.
  def ensure_blocks!
    existing = contents.index_by(&:key)
    self.class::DETAIL_GROUPS.flat_map { |g| g[:fields] }.each_with_index do |(key, _kind, label, hint), i|
      row = existing[key] || contents.build(key: key, content_type: "text")
      row.label = label
      row.hint = hint
      row.position = i
      row.save! if persisted? && (row.new_record? || row.changed?)
    end
    contents.reset if persisted?
    self
  end

  # Form kind (:text / :textarea / :lines) for a key.
  def block_kind(key)
    self.class::DETAIL_GROUPS.flat_map { |g| g[:fields] }.detect { |f| f[0] == key.to_s }&.at(1) || :text
  end
end
