class Section < ApplicationRecord
  extend Enumerize

  has_many :contents, -> { order(:position) },
           as: :parentable, dependent: :destroy, inverse_of: :parentable
  accepts_nested_attributes_for :contents, allow_destroy: true, reject_if: :all_blank

  has_one_attached  :image
  has_many_attached :gallery

  validates :page, :kind, presence: true
  validates :kind, uniqueness: { scope: :page }

  # Public views call this. Never returns nil: a missing section becomes a
  # blank unsaved Section so `sec_text`/`sec_items` render empty instead of
  # crashing the page.
  def self.for(page, kind)
    find_by(page: page.to_s, kind: kind.to_s) || new(page: page.to_s, kind: kind.to_s)
  end

  # Locale-aware content lookup by key. Returns "" when absent so views are safe.
  def text(key)
    contents.detect { |c| c.key == key.to_s }&.value.to_s
  end

  # Friendly admin-facing label; falls back to a humanized kind when unset.
  def display_label
    label.presence || kind.titleize
  end
end
