# Admin Dashboard — Foundation + Home Page Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the CMS foundation (auth, Section/Content model, admin UI, public-read helpers, seed harness) and prove it end-to-end by making the home page fully editable from `/admin`, with no visual change to the live site.

**Architecture:** A server-rendered `/admin` area inside the existing Rails 8 app. Editable content lives in a hybrid model — `Section` (one block of a page) has many `Content` rows (flat text lines) plus JSONB `items` (repeating groups) and `settings` (short config), with ActiveStorage images. Public ERB views read content through `sec_*` helpers that fall back safely so a missing section never crashes a page. Devise guards the admin. A seed loads current home copy into the DB so the first deploy looks identical.

**Tech Stack:** Rails 8.0.4, Ruby 3.2.10, PostgreSQL (JSONB), Devise, enumerize, ActiveStorage (+ image_processing/ruby-vips), Turbo/Stimulus, Propshaft, RSpec + factory_bot + faker + Capybara.

## Global Constraints

- **Bilingual everywhere:** every editable string has an `_ar` and `_en` value; `I18n.locale == :ar` selects Arabic, anything else selects English. Match the existing `Protocol` locale-reader and `ApplicationHelper#loc(ar:, en:)` pattern.
- **Test stack is RSpec** (`rspec-rails`), `factory_bot_rails`, `faker`, Capybara. NOT Minitest. `spec/` does not exist yet — Task 1 installs it.
- **No public visual change on deploy:** the seed (Task 12) must reproduce the current home copy verbatim, and `sec_*` helpers fall back to the seeded/static value.
- **Admin is English-only chrome, NOT locale-scoped.** Content fields always show both AR + EN. Devise routes and `/admin` routes live OUTSIDE the `scope "(:locale)"` block in `config/routes.rb`.
- **User-friendly for non-technical editors:** admin surfaces human `label`/`hint`, never raw `key`/`kind`; pages listed in live order; EN/AR side by side; image preview; "Add another"/"Remove" for repeating groups; success flash; "View this page" link. (Spec §6.1.)
- **DB adapter is PostgreSQL.** Use `jsonb` column type, `default: {}` / `default: []`.
- **Enums via `enumerize`** (already in Gemfile), matching `Protocol`/`Inquiry`.
- **Commit after every task.** Co-author trailer: `Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>`.

---

## File Structure

**Created:**
- `spec/rails_helper.rb`, `spec/spec_helper.rb`, `.rspec` — RSpec setup (Task 1)
- `app/models/section.rb`, `app/models/content.rb` — content model (Tasks 3–4)
- `app/models/user.rb` — Devise admin user (Task 6)
- `db/migrate/*_create_sections.rb`, `*_create_contents.rb`, `*_devise_create_users.rb`, `*_add_status_to_inquiries.rb` (later plan) — migrations
- `app/controllers/admin/base_controller.rb` — auth + layout base (Task 7)
- `app/controllers/admin/dashboard_controller.rb`, `admin/pages_controller.rb`, `admin/sections_controller.rb` (Tasks 8, 9, 10)
- `app/views/layouts/admin.html.erb` + `app/assets/stylesheets/admin.css` — admin chrome (Task 7)
- `app/views/admin/**` — admin screens (Tasks 8–10)
- `app/helpers/content_helper.rb` — public-read `sec_*` helpers (Task 5)
- `app/models/concerns/localized_value.rb` — shared AR/EN reader (Task 3)
- `config/initializers/devise.rb` (generated), `config/locales/devise.en.yml` (generated) (Task 6)
- `lib/tasks/content.rake` — `content:seed` (Task 12)
- `db/seed_content/home.rb` — home section seed data (Task 12)
- `spec/factories/*.rb`, `spec/models/*.rb`, `spec/helpers/*.rb`, `spec/requests/admin/*.rb`, `spec/system/*.rb` — tests (throughout)

**Modified:**
- `Gemfile` — add `devise`, `capybara`, `selenium-webdriver` (Tasks 1, 6)
- `config/routes.rb` — Devise + `namespace :admin` (Tasks 6, 7)
- `app/controllers/pages_controller.rb` — load `@sections` in `home` (Task 11)
- `app/views/pages/home.html.erb`, `app/views/pages/_pillar.html.erb` — read from DB (Task 11)
- `config/application.rb` or generator config — RSpec as test framework (Task 1)

---

### Task 1: Install RSpec, factory_bot, Capybara

**Files:**
- Modify: `Gemfile`
- Create: `.rspec`, `spec/rails_helper.rb`, `spec/spec_helper.rb`, `spec/support/factory_bot.rb`

**Interfaces:**
- Produces: a working `bundle exec rspec` command; `FactoryBot` methods available in specs; `type: :system` Capybara specs runnable.

- [ ] **Step 1: Add test gems to the existing `group :development, :test` block**

`rspec-rails`, `factory_bot_rails`, `faker` are already present. Add Capybara. In `Gemfile`, inside the existing `group :development, :test do` block, add:

```ruby
  gem "capybara"
  gem "selenium-webdriver"
```

- [ ] **Step 2: Install**

Run: `bundle install`
Expected: resolves, installs capybara + selenium-webdriver.

- [ ] **Step 3: Generate RSpec scaffolding**

Run: `bin/rails generate rspec:install`
Expected: creates `.rspec`, `spec/spec_helper.rb`, `spec/rails_helper.rb`.

- [ ] **Step 4: Wire factory_bot + Capybara into rails_helper**

Create `spec/support/factory_bot.rb`:

```ruby
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
```

In `spec/rails_helper.rb`, uncomment the support-file loader line so it reads:

```ruby
Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }
```

And add Capybara + system-test driver near the top of `spec/rails_helper.rb` after `require "rspec/rails"`:

```ruby
require "capybara/rails"

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end
end
```

- [ ] **Step 5: Add a smoke spec**

Create `spec/smoke_spec.rb`:

```ruby
require "rails_helper"

RSpec.describe "RSpec setup" do
  it "runs" do
    expect(1 + 1).to eq(2)
  end
end
```

- [ ] **Step 6: Run it**

Run: `bundle exec rspec spec/smoke_spec.rb`
Expected: `1 example, 0 failures`.

- [ ] **Step 7: Commit**

```bash
git add Gemfile Gemfile.lock .rspec spec/
git commit -m "test: install RSpec, factory_bot, Capybara

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 2: Prepare the test database

**Files:** none created (uses existing schema).

**Interfaces:**
- Produces: a migrated `test` database so model specs can hit the DB.

- [ ] **Step 1: Prepare test DB from current schema**

Run: `RAILS_ENV=test bin/rails db:prepare`
Expected: creates/loads the test database (tables: bridal_leads, inquiries, protocols) with no error.

- [ ] **Step 2: Confirm the smoke spec still passes against the DB**

Run: `bundle exec rspec spec/smoke_spec.rb`
Expected: `1 example, 0 failures`.

- [ ] **Step 3: Commit (no code — skip if nothing changed)**

If `db/schema.rb` was touched, commit it; otherwise no commit needed for this task.

---

### Task 3: `Section` model + migration

**Files:**
- Create: `db/migrate/<ts>_create_sections.rb`, `app/models/section.rb`, `app/models/concerns/localized_value.rb`
- Test: `spec/models/section_spec.rb`, `spec/factories/sections.rb`

**Interfaces:**
- Produces:
  - `Section` with attrs `page:string, kind:string, label:string, position:integer, settings:jsonb({}), items:jsonb([])`, `has_one_attached :image`, `has_many_attached :gallery`, `has_many :contents` (polymorphic `parentable`), `accepts_nested_attributes_for :contents`.
  - Class method `Section.for(page, kind)` → the matching Section or a new unsaved blank `Section.new(page:, kind:)` (never nil).
  - `LocalizedValue` concern providing `localized(ar, en)` → returns `ar` when `I18n.locale == :ar` else `en`, treating blank as nil.

- [ ] **Step 1: Write the failing spec**

Create `spec/factories/sections.rb`:

```ruby
FactoryBot.define do
  factory :section do
    sequence(:kind) { |n| "home_block_#{n}" }
    page { "home" }
    label { "A block" }
    position { 0 }
    settings { {} }
    items { [] }
  end
end
```

Create `spec/models/section_spec.rb`:

```ruby
require "rails_helper"

RSpec.describe Section, type: :model do
  it "requires page and kind" do
    s = Section.new
    expect(s).not_to be_valid
    expect(s.errors[:page]).to be_present
    expect(s.errors[:kind]).to be_present
  end

  it "enforces one kind per page" do
    create(:section, page: "home", kind: "home_hero")
    dup = build(:section, page: "home", kind: "home_hero")
    expect(dup).not_to be_valid
  end

  it "allows the same kind on a different page" do
    create(:section, page: "home", kind: "hero")
    expect(build(:section, page: "dr_maysa", kind: "hero")).to be_valid
  end

  describe ".for" do
    it "returns the matching section" do
      s = create(:section, page: "home", kind: "home_hero")
      expect(Section.for("home", "home_hero")).to eq(s)
    end

    it "returns a blank unsaved section when none exists" do
      result = Section.for("home", "missing")
      expect(result).to be_a(Section)
      expect(result).to be_new_record
      expect(result.contents).to be_empty
      expect(result.items).to eq([])
    end
  end
end
```

- [ ] **Step 2: Run to verify it fails**

Run: `bundle exec rspec spec/models/section_spec.rb`
Expected: FAIL — `uninitialized constant Section`.

- [ ] **Step 3: Create the migration**

Create `db/migrate/<ts>_create_sections.rb` (generate the timestamp with `bin/rails generate migration CreateSections` then replace its body, OR write the file with a current UTC timestamp prefix):

```ruby
class CreateSections < ActiveRecord::Migration[8.0]
  def change
    create_table :sections do |t|
      t.string  :page,     null: false
      t.string  :kind,     null: false
      t.string  :label
      t.integer :position, null: false, default: 0
      t.jsonb   :settings, null: false, default: {}
      t.jsonb   :items,    null: false, default: []
      t.timestamps
    end
    add_index :sections, [:page, :kind], unique: true
    add_index :sections, :page
  end
end
```

- [ ] **Step 4: Create the concern**

Create `app/models/concerns/localized_value.rb`:

```ruby
module LocalizedValue
  extend ActiveSupport::Concern

  # Returns the Arabic value when the active locale is Arabic, else English.
  # Blank strings are treated as nil so callers can chain `|| fallback`.
  def localized(ar, en)
    value = I18n.locale == :ar ? ar : en
    value.presence
  end
end
```

- [ ] **Step 5: Create the model**

Create `app/models/section.rb`:

```ruby
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
end
```

- [ ] **Step 6: Migrate (dev + test)**

Run: `bin/rails db:migrate && RAILS_ENV=test bin/rails db:migrate`
Expected: creates `sections` table in both DBs.

- [ ] **Step 7: Run the spec**

Run: `bundle exec rspec spec/models/section_spec.rb`
Expected: `4 examples, 0 failures`.

- [ ] **Step 8: Commit**

```bash
git add db/ app/models/section.rb app/models/concerns/localized_value.rb spec/
git commit -m "feat: Section model with page/kind blocks and .for finder

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 4: `Content` model + migration

**Files:**
- Create: `db/migrate/<ts>_create_contents.rb`, `app/models/content.rb`
- Test: `spec/models/content_spec.rb`, `spec/factories/contents.rb`

**Interfaces:**
- Consumes: `Section` (Task 3), `LocalizedValue` concern (Task 3).
- Produces:
  - `Content` with `parentable_type/parentable_id` (polymorphic), `key:string, label:string, hint:string, value_ar:text, value_en:text, content_type:string(default "text"), position:integer(default 0)`.
  - Instance method `Content#value` → locale-aware value via `localized(value_ar, value_en)`.
  - `content_type` enumerized: `text | richtext | plain`.

- [ ] **Step 1: Write the failing spec**

Create `spec/factories/contents.rb`:

```ruby
FactoryBot.define do
  factory :content do
    association :parentable, factory: :section
    sequence(:key) { |n| "field_#{n}" }
    label { "A field" }
    value_en { "English" }
    value_ar { "عربى" }
    content_type { "text" }
    position { 0 }
  end
end
```

Create `spec/models/content_spec.rb`:

```ruby
require "rails_helper"

RSpec.describe Content, type: :model do
  it "requires a key" do
    expect(build(:content, key: nil)).not_to be_valid
  end

  describe "#value" do
    it "returns English outside Arabic locale" do
      c = build(:content, value_ar: "عربى", value_en: "English")
      I18n.with_locale(:en) { expect(c.value).to eq("English") }
    end

    it "returns Arabic in the Arabic locale" do
      c = build(:content, value_ar: "عربى", value_en: "English")
      I18n.with_locale(:ar) { expect(c.value).to eq("عربى") }
    end

    it "returns nil when the locale value is blank" do
      c = build(:content, value_ar: "", value_en: "English")
      I18n.with_locale(:ar) { expect(c.value).to be_nil }
    end
  end
end
```

- [ ] **Step 2: Run to verify it fails**

Run: `bundle exec rspec spec/models/content_spec.rb`
Expected: FAIL — `uninitialized constant Content`.

- [ ] **Step 3: Create the migration**

Create `db/migrate/<ts>_create_contents.rb`:

```ruby
class CreateContents < ActiveRecord::Migration[8.0]
  def change
    create_table :contents do |t|
      t.references :parentable, polymorphic: true, null: false
      t.string  :key,          null: false
      t.string  :label
      t.string  :hint
      t.text    :value_ar
      t.text    :value_en
      t.string  :content_type, null: false, default: "text"
      t.integer :position,     null: false, default: 0
      t.timestamps
    end
    add_index :contents, [:parentable_type, :parentable_id, :key],
              unique: true, name: "index_contents_on_parent_and_key"
  end
end
```

- [ ] **Step 4: Create the model**

Create `app/models/content.rb`:

```ruby
class Content < ApplicationRecord
  include LocalizedValue
  extend Enumerize

  belongs_to :parentable, polymorphic: true, inverse_of: :contents

  enumerize :content_type, in: %i[text richtext plain], default: :text

  validates :key, presence: true

  # Locale-aware reader, mirrors Protocol's localized readers.
  def value
    localized(value_ar, value_en)
  end
end
```

- [ ] **Step 5: Migrate**

Run: `bin/rails db:migrate && RAILS_ENV=test bin/rails db:migrate`
Expected: creates `contents` table in both DBs.

- [ ] **Step 6: Run the spec**

Run: `bundle exec rspec spec/models/content_spec.rb`
Expected: `4 examples, 0 failures`.

- [ ] **Step 7: Commit**

```bash
git add db/ app/models/content.rb spec/
git commit -m "feat: Content model with locale-aware value reader

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 5: Public-read `sec_*` helpers

**Files:**
- Create: `app/helpers/content_helper.rb`
- Test: `spec/helpers/content_helper_spec.rb`

**Interfaces:**
- Consumes: `Section.for` (Task 3), `Content#value` (Task 4), existing `ApplicationHelper#ns_image` (asset-path fallback).
- Produces (used by Task 11 and every later page):
  - `sec(page, kind)` → memoized `Section.for` (per-request, keyed by "page/kind").
  - `sec_text(page, kind, key)` → the Content's locale value, or `""`.
  - `sec_items(page, kind)` → the section's JSONB `items` array (or `[]`).
  - `sec_image(page, kind, fallback_key)` → ActiveStorage `image` URL when attached, else `ns_image(fallback_key)`.

- [ ] **Step 1: Write the failing spec**

Create `spec/helpers/content_helper_spec.rb`:

```ruby
require "rails_helper"

RSpec.describe ContentHelper, type: :helper do
  describe "#sec_text" do
    it "returns the English value for an existing content" do
      section = create(:section, page: "home", kind: "home_hero")
      create(:content, parentable: section, key: "headline",
             value_en: "Hello", value_ar: "مرحبا")
      I18n.with_locale(:en) do
        expect(helper.sec_text("home", "home_hero", "headline")).to eq("Hello")
      end
    end

    it "returns the Arabic value in the Arabic locale" do
      section = create(:section, page: "home", kind: "home_hero")
      create(:content, parentable: section, key: "headline",
             value_en: "Hello", value_ar: "مرحبا")
      I18n.with_locale(:ar) do
        expect(helper.sec_text("home", "home_hero", "headline")).to eq("مرحبا")
      end
    end

    it "returns empty string when the section is missing" do
      expect(helper.sec_text("home", "nope", "headline")).to eq("")
    end

    it "returns empty string when the key is missing" do
      create(:section, page: "home", kind: "home_hero")
      expect(helper.sec_text("home", "home_hero", "absent")).to eq("")
    end
  end

  describe "#sec_items" do
    it "returns the items array" do
      create(:section, page: "home", kind: "home_voices",
             items: [{ "q" => { "en" => "hi" } }])
      expect(helper.sec_items("home", "home_voices")).to eq([{ "q" => { "en" => "hi" } }])
    end

    it "returns [] when the section is missing" do
      expect(helper.sec_items("home", "nope")).to eq([])
    end
  end

  describe "#sec_image" do
    it "falls back to the static asset when no image is attached" do
      create(:section, page: "home", kind: "home_hero")
      # ns_image returns an asset path string; just assert it is non-blank.
      expect(helper.sec_image("home", "home_hero", :portrait_natural)).to be_present
    end
  end
end
```

- [ ] **Step 2: Run to verify it fails**

Run: `bundle exec rspec spec/helpers/content_helper_spec.rb`
Expected: FAIL — `uninitialized constant ContentHelper`.

- [ ] **Step 3: Create the helper**

Create `app/helpers/content_helper.rb`:

```ruby
module ContentHelper
  # Memoized per request. Never nil (Section.for returns a blank when missing).
  def sec(page, kind)
    @__sections ||= {}
    @__sections["#{page}/#{kind}"] ||= Section.for(page, kind)
  end

  # Locale-aware text for a Content key. Safe empty string when absent.
  def sec_text(page, kind, key)
    sec(page, kind).text(key)
  end

  # JSONB items array for a repeating-group section. Safe [] when absent.
  def sec_items(page, kind)
    sec(page, kind).items || []
  end

  # ActiveStorage image URL when attached, else the static asset fallback.
  def sec_image(page, kind, fallback_key)
    section = sec(page, kind)
    if section.persisted? && section.image.attached?
      url_for(section.image)
    else
      ns_image(fallback_key)
    end
  end
end
```

- [ ] **Step 4: Run the spec**

Run: `bundle exec rspec spec/helpers/content_helper_spec.rb`
Expected: `7 examples, 0 failures`.

- [ ] **Step 5: Commit**

```bash
git add app/helpers/content_helper.rb spec/
git commit -m "feat: sec_text/sec_items/sec_image public-read helpers with safe fallbacks

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 6: Devise + `User` model

**Files:**
- Modify: `Gemfile`, `config/routes.rb`
- Create: `app/models/user.rb` (generated, then edited), migration, `spec/models/user_spec.rb`, `spec/factories/users.rb`

**Interfaces:**
- Produces:
  - `User` (Devise `:database_authenticatable, :recoverable, :rememberable, :validatable`) with `role` enumerized `admin | editor` (default `editor`).
  - `User#admin?` predicate (from enumerize predicates).
  - Devise session routes mounted OUTSIDE the locale scope.

- [ ] **Step 1: Add Devise to the Gemfile (top-level, not test-only)**

In `Gemfile`, after the `stimulus-rails` line, add:

```ruby
gem "devise"
```

- [ ] **Step 2: Install**

Run: `bundle install`
Expected: installs devise.

- [ ] **Step 3: Run the Devise generator**

Run: `bin/rails generate devise:install`
Expected: creates `config/initializers/devise.rb` and `config/locales/devise.en.yml`. (Ignore the mailer host advice — not needed for this task.)

- [ ] **Step 4: Generate the User model**

Run: `bin/rails generate devise User`
Expected: creates `app/models/user.rb`, a migration, and adds `devise_for :users` to routes.

- [ ] **Step 5: Add a `role` column to the generated migration**

In the generated `db/migrate/<ts>_devise_create_users.rb`, inside `create_table :users`, add after the Devise columns (before `t.timestamps`):

```ruby
      t.string :role, null: false, default: "editor"
```

- [ ] **Step 6: Migrate**

Run: `bin/rails db:migrate && RAILS_ENV=test bin/rails db:migrate`
Expected: creates `users` table.

- [ ] **Step 7: Edit the User model to add the role enum**

Replace `app/models/user.rb` with:

```ruby
class User < ApplicationRecord
  extend Enumerize

  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  enumerize :role, in: %i[admin editor], default: :editor, predicates: true
end
```

- [ ] **Step 8: Move Devise routes out of the locale scope**

Open `config/routes.rb`. The generator inserted `devise_for :users`. Ensure it sits at the TOP LEVEL (not inside `scope "(:locale)"`). If the generator placed it elsewhere, move it just below the `up` health-check line:

```ruby
  devise_for :users
```

- [ ] **Step 9: Write the User spec**

Create `spec/factories/users.rb`:

```ruby
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "editor#{n}@neuskin.test" }
    password { "password123" }
    role { "editor" }

    factory :admin_user do
      role { "admin" }
    end
  end
end
```

Create `spec/models/user_spec.rb`:

```ruby
require "rails_helper"

RSpec.describe User, type: :model do
  it "defaults to the editor role" do
    expect(build(:user).role).to eq("editor")
  end

  it "exposes an admin? predicate" do
    expect(build(:admin_user).admin?).to be(true)
    expect(build(:user).admin?).to be(false)
  end

  it "requires a valid email and password" do
    expect(build(:user, email: nil)).not_to be_valid
    expect(build(:user, password: nil)).not_to be_valid
  end
end
```

- [ ] **Step 10: Run the spec**

Run: `bundle exec rspec spec/models/user_spec.rb`
Expected: `3 examples, 0 failures`.

- [ ] **Step 11: Commit**

```bash
git add Gemfile Gemfile.lock config/ db/ app/models/user.rb spec/
git commit -m "feat: Devise User model with admin/editor roles

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 7: Admin base controller, layout, and namespace

**Files:**
- Create: `app/controllers/admin/base_controller.rb`, `app/views/layouts/admin.html.erb`, `app/assets/stylesheets/admin.css`
- Modify: `config/routes.rb`
- Test: `spec/requests/admin/auth_spec.rb`

**Interfaces:**
- Consumes: `User` + Devise (Task 6).
- Produces:
  - `Admin::BaseController < ApplicationController` with `layout "admin"`, `before_action :authenticate_user!`, and `require_admin!` helper (redirects non-admins) available to subclasses.
  - `namespace :admin` block in routes (empty for now; controllers added in later tasks).
  - Admin layout rendering `yield`, flash messages, and a nav.

- [ ] **Step 1: Add the admin namespace + a dashboard route placeholder**

In `config/routes.rb`, at the TOP LEVEL (outside the locale scope), add:

```ruby
  namespace :admin do
    root to: "dashboard#index"
  end
```

(The `dashboard` controller is created in Task 8; this task only needs the namespace to exist for the auth spec, which hits `/admin`.)

- [ ] **Step 2: Write the failing auth spec**

Create `spec/requests/admin/auth_spec.rb`:

```ruby
require "rails_helper"

RSpec.describe "Admin authentication", type: :request do
  it "redirects an unauthenticated visitor to sign in" do
    get "/admin"
    expect(response).to redirect_to("/users/sign_in")
  end
end
```

- [ ] **Step 3: Run to verify it fails**

Run: `bundle exec rspec spec/requests/admin/auth_spec.rb`
Expected: FAIL — routing error / missing controller (no `Admin::DashboardController` yet, or uninitialized `Admin::BaseController`).

- [ ] **Step 4: Create the base controller**

Create `app/controllers/admin/base_controller.rb`:

```ruby
module Admin
  class BaseController < ApplicationController
    layout "admin"

    # Admin chrome is English-only; never run the public locale switch here.
    skip_around_action :switch_locale, raise: false

    before_action :authenticate_user!

    private

    # Guard for admin-only areas (e.g. user management). Editors are bounced.
    def require_admin!
      return if current_user&.admin?

      redirect_to admin_root_path, alert: "Admins only."
    end
  end
end
```

- [ ] **Step 5: Create a minimal dashboard controller so `/admin` resolves**

Create `app/controllers/admin/dashboard_controller.rb`:

```ruby
module Admin
  class DashboardController < BaseController
    def index; end
  end
end
```

Create `app/views/admin/dashboard/index.html.erb`:

```erb
<h1>Dashboard</h1>
```

- [ ] **Step 6: Create the admin layout**

Create `app/views/layouts/admin.html.erb`:

```erb
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>NeuSkin Admin</title>
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>
    <%= stylesheet_link_tag "admin", "data-turbo-track": "reload" %>
    <%= javascript_importmap_tags %>
  </head>
  <body class="admin">
    <header class="admin-bar">
      <a href="<%= admin_root_path %>" class="admin-brand">NeuSkin Admin</a>
      <nav class="admin-nav">
        <%= link_to "Pages", admin_pages_path if respond_to?(:admin_pages_path) %>
        <% if user_signed_in? %>
          <span class="admin-user"><%= current_user.email %></span>
          <%= button_to "Sign out", destroy_user_session_path, method: :delete, class: "admin-signout" %>
        <% end %>
      </nav>
    </header>

    <% if notice %><p class="flash flash-notice"><%= notice %></p><% end %>
    <% if alert %><p class="flash flash-alert"><%= alert %></p><% end %>

    <main class="admin-main">
      <%= yield %>
    </main>
  </body>
</html>
```

- [ ] **Step 7: Create admin styles**

Create `app/assets/stylesheets/admin.css`:

```css
.admin { font-family: system-ui, sans-serif; margin: 0; color: #1a1a1a; background: #f6f6f4; }
.admin-bar { display: flex; justify-content: space-between; align-items: center;
  padding: 12px 24px; background: #fff; border-bottom: 1px solid #e2e2dd; }
.admin-brand { font-weight: 600; text-decoration: none; color: #1a1a1a; }
.admin-nav { display: flex; gap: 16px; align-items: center; }
.admin-main { max-width: 900px; margin: 32px auto; padding: 0 24px; }
.flash { max-width: 900px; margin: 16px auto; padding: 12px 16px; border-radius: 6px; }
.flash-notice { background: #e7f5ea; color: #1e5631; }
.flash-alert { background: #fdeaea; color: #8a1f1f; }
.field { margin-bottom: 16px; }
.field label { display: block; font-weight: 600; margin-bottom: 4px; }
.field .hint { font-size: 12px; color: #777; margin: 2px 0 6px; }
.field-pair { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
.field-pair .ar input, .field-pair .ar textarea { direction: rtl; }
input[type=text], textarea { width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; font: inherit; }
.btn-primary { background: #1a1a1a; color: #fff; border: 0; padding: 10px 18px; border-radius: 6px; cursor: pointer; }
.section-card { background: #fff; border: 1px solid #e2e2dd; border-radius: 8px; padding: 20px; margin-bottom: 16px; }
```

Ensure Propshaft serves it — it is under `app/assets/stylesheets`, which is already on the asset path. No manifest edit needed for `stylesheet_link_tag "admin"` under Propshaft.

- [ ] **Step 8: Run the auth spec**

Run: `bundle exec rspec spec/requests/admin/auth_spec.rb`
Expected: `1 example, 0 failures` (redirects to `/users/sign_in`).

- [ ] **Step 9: Commit**

```bash
git add config/routes.rb app/controllers/admin/ app/views/layouts/admin.html.erb app/views/admin/ app/assets/stylesheets/admin.css spec/
git commit -m "feat: admin namespace, base controller auth guard, and layout

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 8: Admin dashboard content

**Files:**
- Modify: `app/controllers/admin/dashboard_controller.rb`, `app/views/admin/dashboard/index.html.erb`
- Test: `spec/requests/admin/dashboard_spec.rb`

**Interfaces:**
- Consumes: `Inquiry`, `BridalLead`, `Protocol` (existing), `Section` (Task 3), auth (Task 7).
- Produces: a signed-in dashboard showing counts.

- [ ] **Step 1: Write the failing spec**

Create `spec/requests/admin/dashboard_spec.rb`:

```ruby
require "rails_helper"

RSpec.describe "Admin dashboard", type: :request do
  it "shows counts to a signed-in user" do
    user = create(:user)
    sign_in user
    get "/admin"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Dashboard")
  end
end
```

Add Devise request helpers — in `spec/rails_helper.rb`, inside the `RSpec.configure` block, add:

```ruby
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :system
```

- [ ] **Step 2: Run to verify it fails**

Run: `bundle exec rspec spec/requests/admin/dashboard_spec.rb`
Expected: FAIL — body does not yet include counts / passes trivially only on "Dashboard"; proceed to enrich.

- [ ] **Step 3: Fill in the dashboard controller**

Replace `app/controllers/admin/dashboard_controller.rb`:

```ruby
module Admin
  class DashboardController < BaseController
    def index
      @inquiries_count    = Inquiry.count
      @bridal_leads_count = BridalLead.count
      @protocols_count    = Protocol.count
      @sections_count     = Section.count
    end
  end
end
```

- [ ] **Step 4: Fill in the dashboard view**

Replace `app/views/admin/dashboard/index.html.erb`:

```erb
<h1>Dashboard</h1>

<div class="tiles">
  <div class="section-card"><strong><%= @inquiries_count %></strong><br>Inquiries</div>
  <div class="section-card"><strong><%= @bridal_leads_count %></strong><br>Bridal leads</div>
  <div class="section-card"><strong><%= @protocols_count %></strong><br>Protocols</div>
  <div class="section-card"><strong><%= @sections_count %></strong><br>Editable sections</div>
</div>

<p style="margin-top:24px"><%= link_to "Edit site pages →", admin_pages_path %></p>
```

- [ ] **Step 5: Run the spec**

Run: `bundle exec rspec spec/requests/admin/dashboard_spec.rb`
Expected: `1 example, 0 failures`.

- [ ] **Step 6: Commit**

```bash
git add app/controllers/admin/dashboard_controller.rb app/views/admin/dashboard/ spec/rails_helper.rb spec/requests/admin/dashboard_spec.rb
git commit -m "feat: admin dashboard with content counts

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 9: Admin pages index + page show

**Files:**
- Create: `app/controllers/admin/pages_controller.rb`, `app/views/admin/pages/index.html.erb`, `app/views/admin/pages/show.html.erb`, `config/pages.rb` (page registry)
- Modify: `config/routes.rb`
- Test: `spec/requests/admin/pages_spec.rb`

**Interfaces:**
- Consumes: `Section` (Task 3), auth (Task 7).
- Produces:
  - `Admin::PagesController#index` — lists pages from a registry with friendly names.
  - `#show` — lists a page's sections (ordered by `position`) with their `label`, linking to section edit.
  - A page registry constant `SitePages::LIST` mapping page slug → friendly name, so the index shows human names, not enum codes.

- [ ] **Step 1: Create the page registry**

Create `config/pages.rb`:

```ruby
# Friendly names for each editable page. Drives the admin Pages index so a
# non-technical editor sees "The Clinic", not "the_clinic". Order = nav order.
module SitePages
  LIST = [
    { slug: "home",           name: "Home" },
    { slug: "dr_maysa",       name: "Dr. Maysa" },
    { slug: "the_clinic",     name: "The Clinic" },
    { slug: "maysa_method",   name: "The Maysa Method" },
    { slug: "the_team",       name: "The Medical Team" },
    { slug: "treatments",     name: "Treatments" },
    { slug: "private_care",   name: "Private Care" },
    { slug: "journal",        name: "Journal" },
    { slug: "stories",        name: "Patient Stories" },
    { slug: "faq",            name: "FAQ" },
    { slug: "legal",          name: "Legal" },
    { slug: "protocols_index", name: "Protocols (hub)" },
    { slug: "bridal",         name: "Bridal Concierge" },
    { slug: "global",         name: "Site-wide" }
  ].freeze

  def self.name_for(slug)
    LIST.find { |p| p[:slug] == slug.to_s }&.fetch(:name) || slug.to_s.titleize
  end
end
```

Require it — add to `config/application.rb` inside the `Application` class:

```ruby
    require_relative "pages"
```

- [ ] **Step 2: Add routes**

In `config/routes.rb`, inside `namespace :admin`, add:

```ruby
    resources :pages, only: [:index, :show]
```

- [ ] **Step 3: Write the failing spec**

Create `spec/requests/admin/pages_spec.rb`:

```ruby
require "rails_helper"

RSpec.describe "Admin pages", type: :request do
  before { sign_in create(:user) }

  it "lists editable pages by friendly name" do
    get "/admin/pages"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Home")
    expect(response.body).to include("The Clinic")
  end

  it "shows a page's sections in order" do
    create(:section, page: "home", kind: "home_hero", label: "Hero", position: 0)
    create(:section, page: "home", kind: "home_promise", label: "The Promise", position: 1)
    get "/admin/pages/home"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Hero")
    expect(response.body).to include("The Promise")
  end
end
```

- [ ] **Step 4: Run to verify it fails**

Run: `bundle exec rspec spec/requests/admin/pages_spec.rb`
Expected: FAIL — missing controller/action.

- [ ] **Step 5: Create the controller**

Create `app/controllers/admin/pages_controller.rb`:

```ruby
module Admin
  class PagesController < BaseController
    def index
      @pages = SitePages::LIST
    end

    def show
      @slug     = params[:id]
      @name     = SitePages.name_for(@slug)
      @sections = Section.where(page: @slug).order(:position)
    end
  end
end
```

- [ ] **Step 6: Create the index view**

Create `app/views/admin/pages/index.html.erb`:

```erb
<h1>Site pages</h1>
<p>Choose a page to edit its content.</p>

<ul class="page-list">
  <% @pages.each do |page| %>
    <li class="section-card">
      <%= link_to page[:name], admin_page_path(page[:slug]) %>
    </li>
  <% end %>
</ul>
```

- [ ] **Step 7: Create the show view**

Create `app/views/admin/pages/show.html.erb`:

```erb
<p><%= link_to "← All pages", admin_pages_path %></p>
<h1><%= @name %></h1>

<% if @sections.any? %>
  <p>Sections appear in the same order as on the live page.</p>
  <ul class="page-list">
    <% @sections.each do |section| %>
      <li class="section-card">
        <%= link_to (section.label.presence || section.kind.titleize),
                    admin_section_path(section) %>
      </li>
    <% end %>
  </ul>
<% else %>
  <p>No editable sections yet for this page. Run <code>rails content:seed</code>.</p>
<% end %>
```

- [ ] **Step 8: Run the spec**

Run: `bundle exec rspec spec/requests/admin/pages_spec.rb`
Expected: `2 examples, 0 failures`.

- [ ] **Step 9: Commit**

```bash
git add config/pages.rb config/application.rb config/routes.rb app/controllers/admin/pages_controller.rb app/views/admin/pages/ spec/
git commit -m "feat: admin pages index and per-page section list

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 10: Admin section edit form (Content rows + items + image + settings)

**Files:**
- Create: `app/controllers/admin/sections_controller.rb`, `app/views/admin/sections/show.html.erb`, `app/views/admin/sections/_content_fields.html.erb`, `app/views/admin/sections/_item_fields.html.erb`
- Modify: `config/routes.rb`
- Test: `spec/requests/admin/sections_spec.rb`

**Interfaces:**
- Consumes: `Section` (Task 3), `Content` (Task 4), auth (Task 7).
- Produces:
  - `Admin::SectionsController#show` (edit form) and `#update`.
  - Strong params permitting: `label`, `settings` (hash), `items` (array — accepted as JSON string field and parsed), `image`, and `contents_attributes: [:id, :key, :label, :hint, :value_ar, :value_en, :content_type, :position, :_destroy]`.
  - `#update` redirects to `admin_section_path` with a success notice on success; re-renders `show` on failure.

- [ ] **Step 1: Add routes**

In `config/routes.rb`, inside `namespace :admin`, add:

```ruby
    resources :sections, only: [:show, :update]
```

- [ ] **Step 2: Write the failing spec**

Create `spec/requests/admin/sections_spec.rb`:

```ruby
require "rails_helper"

RSpec.describe "Admin sections", type: :request do
  before { sign_in create(:user) }

  it "renders the edit form with content labels, not raw keys" do
    section = create(:section, page: "home", kind: "home_hero", label: "Hero")
    create(:content, parentable: section, key: "headline",
           label: "Headline", value_en: "Old headline")
    get "/admin/sections/#{section.id}"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Headline")     # friendly label
    expect(response.body).to include("Old headline")  # current value
  end

  it "updates a content value" do
    section = create(:section, page: "home", kind: "home_hero", label: "Hero")
    content = create(:content, parentable: section, key: "headline",
                     label: "Headline", value_en: "Old")
    patch "/admin/sections/#{section.id}", params: {
      section: {
        label: "Hero",
        contents_attributes: {
          "0" => { id: content.id, key: "headline", label: "Headline",
                   value_en: "New headline", value_ar: content.value_ar,
                   content_type: "text", position: 0 }
        }
      }
    }
    expect(response).to redirect_to("/admin/sections/#{section.id}")
    expect(content.reload.value_en).to eq("New headline")
  end

  it "updates JSONB items from a JSON text field" do
    section = create(:section, page: "home", kind: "home_voices", label: "Voices")
    patch "/admin/sections/#{section.id}", params: {
      section: {
        items_json: '[{"q":{"en":"Great","ar":"رائع"},"by":{"en":"L.M.","ar":"ل.م."}}]'
      }
    }
    expect(section.reload.items).to eq(
      [{ "q" => { "en" => "Great", "ar" => "رائع" }, "by" => { "en" => "L.M.", "ar" => "ل.م." } }]
    )
  end
end
```

- [ ] **Step 3: Run to verify it fails**

Run: `bundle exec rspec spec/requests/admin/sections_spec.rb`
Expected: FAIL — missing controller/action.

- [ ] **Step 4: Create the controller**

Create `app/controllers/admin/sections_controller.rb`:

```ruby
module Admin
  class SectionsController < BaseController
    before_action :set_section, only: [:show, :update]

    def show; end

    def update
      assign_items
      if @section.update(section_params)
        redirect_to admin_section_path(@section), notice: "Saved."
      else
        render :show, status: :unprocessable_entity
      end
    end

    private

    def set_section
      @section = Section.find(params[:id])
    end

    # `items` is edited as a JSON text field for now (repeating-group UI is a
    # later refinement). Parse it into the JSONB column; ignore blank/invalid.
    def assign_items
      raw = params.dig(:section, :items_json)
      return if raw.nil?

      @section.items = raw.blank? ? [] : JSON.parse(raw)
    rescue JSON::ParserError
      @section.errors.add(:base, "Items JSON is invalid.")
      render :show, status: :unprocessable_entity
    end

    def section_params
      params.require(:section).permit(
        :label, :image,
        settings: {},
        contents_attributes: [
          :id, :key, :label, :hint, :value_ar, :value_en,
          :content_type, :position, :_destroy
        ]
      )
    end
  end
end
```

- [ ] **Step 5: Create the content-fields partial**

Create `app/views/admin/sections/_content_fields.html.erb`:

```erb
<%# Renders one Content row: friendly label + EN/AR inputs side by side. %>
<div class="section-card">
  <%= form.hidden_field :id %>
  <%= form.hidden_field :key %>
  <%= form.hidden_field :content_type %>
  <%= form.hidden_field :position %>

  <div class="field">
    <label><%= form.object.label.presence || form.object.key.titleize %></label>
    <% if form.object.hint.present? %><p class="hint"><%= form.object.hint %></p><% end %>
    <div class="field-pair">
      <div class="en">
        <label>English</label>
        <%= form.text_area :value_en, rows: 2 %>
      </div>
      <div class="ar">
        <label>العربية (Arabic)</label>
        <%= form.text_area :value_ar, rows: 2, dir: "rtl" %>
      </div>
    </div>
  </div>
</div>
```

- [ ] **Step 6: Create the item-fields partial (read-only JSON for now)**

Create `app/views/admin/sections/_item_fields.html.erb`:

```erb
<%# Repeating groups are edited as JSON here; a card-based editor is a later
    refinement. Shows current items so the editor can copy the shape. %>
<div class="field">
  <label>Repeating items (advanced)</label>
  <p class="hint">Each item is one card/quote/entry. Edit as JSON; keep the
    <code>{"key": {"en": "...", "ar": "..."}}</code> shape.</p>
  <%= text_area_tag "section[items_json]", JSON.pretty_generate(@section.items || []), rows: 10 %>
</div>
```

- [ ] **Step 7: Create the show/edit view**

Create `app/views/admin/sections/show.html.erb`:

```erb
<p><%= link_to "← #{SitePages.name_for(@section.page)}", admin_page_path(@section.page) %></p>
<h1><%= @section.label.presence || @section.kind.titleize %></h1>

<% locale_param = @section.page == "home" ? {} : {} %>
<p><%= link_to "View this page ↗", main_app.root_path, target: "_blank" if @section.page == "home" %></p>

<%= form_with model: @section, url: admin_section_path(@section), method: :patch do |form| %>
  <% if @section.errors.any? %>
    <div class="flash flash-alert">
      <%= @section.errors.full_messages.to_sentence %>
    </div>
  <% end %>

  <%= form.hidden_field :label %>

  <% if @section.image.attached? %>
    <div class="field">
      <label>Current image</label><br>
      <%= image_tag url_for(@section.image), style: "max-width:220px;border-radius:6px" %>
    </div>
  <% end %>
  <div class="field">
    <label>Replace image</label>
    <%= form.file_field :image %>
  </div>

  <h2>Text</h2>
  <%= form.fields_for :contents do |content_form| %>
    <%= render "content_fields", form: content_form %>
  <% end %>

  <% if @section.items.present? %>
    <h2>Repeating items</h2>
    <%= render "item_fields" %>
  <% end %>

  <p style="margin-top:20px"><%= form.submit "Save", class: "btn-primary" %></p>
<% end %>
```

- [ ] **Step 8: Run the spec**

Run: `bundle exec rspec spec/requests/admin/sections_spec.rb`
Expected: `3 examples, 0 failures`.

- [ ] **Step 9: Commit**

```bash
git add config/routes.rb app/controllers/admin/sections_controller.rb app/views/admin/sections/ spec/
git commit -m "feat: admin section edit form (content rows, items JSON, image)

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 11: Rewire the home view to read from the DB

**Files:**
- Modify: `app/controllers/pages_controller.rb`, `app/views/pages/home.html.erb`, `app/views/pages/_pillar.html.erb`
- Test: `spec/system/home_content_spec.rb`

**Interfaces:**
- Consumes: `sec_text`/`sec_items`/`sec_image` (Task 5), `Section`/`Content` (Tasks 3–4). This task assumes the seed (Task 12) is NOT yet run — so `sec_text` returns `""`. To avoid a blank homepage before seeding, each rewired call uses `.presence || t("...")` fallback to the existing i18n key. After Task 12 the DB value wins.
- Produces: a home page that renders DB content when present and the current i18n copy otherwise — identical output either way.

- [ ] **Step 1: Write the failing system spec**

Create `spec/system/home_content_spec.rb`:

```ruby
require "rails_helper"

RSpec.describe "Home page content", type: :system do
  it "renders the DB hero headline when a section provides it" do
    section = create(:section, page: "home", kind: "home_hero", label: "Hero")
    create(:content, parentable: section, key: "hero_h1",
           label: "Headline", value_en: "Measured beauty.", value_ar: "جمالٌ مقاس.")

    visit root_path(locale: "en")
    expect(page).to have_content("Measured beauty.")
  end

  it "falls back to the i18n copy when no section exists" do
    visit root_path(locale: "en")
    expect(page).to have_content(I18n.t("home.hero_h1", locale: :en))
  end
end
```

- [ ] **Step 2: Run to verify it fails**

Run: `bundle exec rspec spec/system/home_content_spec.rb`
Expected: FAIL — first example fails (view still hard-uses `t("home.hero_h1")`).

- [ ] **Step 3: Load sections in the controller**

In `app/controllers/pages_controller.rb`, replace `def home` with:

```ruby
  def home
    @sections = Section.where(page: "home").includes(:contents).index_by(&:kind)
  end
```

- [ ] **Step 4: Rewire the hero + credibility + promise in the view**

In `app/views/pages/home.html.erb`, replace the hero `<h1>`/`<p>` and the promise/founder/voice/invite text calls with `sec_text` + i18n fallback. Concretely:

- Line 5 `<%= t("home.hero_h1").html_safe %>` → `<%= (sec_text("home", "home_hero", "hero_h1").presence || t("home.hero_h1")).html_safe %>`
- Line 7 `<%= t("home.hero_sub") %>` → `<%= sec_text("home", "home_hero", "hero_sub").presence || t("home.hero_sub") %>`
- Line 31 `<%= t("home.promise_label") %>` → `<%= sec_text("home", "home_promise", "label").presence || t("home.promise_label") %>`
- Line 32 `<%= t("home.promise_title") %>` → `<%= sec_text("home", "home_promise", "title").presence || t("home.promise_title") %>`
- Line 54 `<%= t("home.founder_label") %>` → `<%= sec_text("home", "home_founder", "label").presence || t("home.founder_label") %>`
- Line 56 `<%= t("home.founder_quote") %>` → `<%= sec_text("home", "home_founder", "quote").presence || t("home.founder_quote") %>`
- Line 58 `<%= t("home.founder_body") %>` → `<%= sec_text("home", "home_founder", "body").presence || t("home.founder_body") %>`
- Line 60 `<%= t("home.founder_link") %>` → `<%= sec_text("home", "home_founder", "link").presence || t("home.founder_link") %>`
- Line 100 `<%= t("home.voice_label") %>` → `<%= sec_text("home", "home_voices", "label").presence || t("home.voice_label") %>`
- Line 101 `<%= t("home.voice_title") %>` → `<%= sec_text("home", "home_voices", "title").presence || t("home.voice_title") %>`
- Line 119 `<%= t("home.invite_label") %>` → `<%= sec_text("home", "home_invite", "label").presence || t("home.invite_label") %>`
- Line 120 `<%= t("home.invite_line") %>` → `<%= sec_text("home", "home_invite", "line").presence || t("home.invite_line") %>`
- Line 88 `<%= t("home.protocols_title") %>` → `<%= sec_text("home", "home_protocols", "title").presence || t("home.protocols_title") %>`

Leave `Protocol.all`, `t("cta.*")`, and the concern/credibility loops as-is for now (concern/credibility/voices repeating groups are migrated to `sec_items` in a later page-refinement task; keeping the i18n loop here preserves current output).

- [ ] **Step 5: Run the spec**

Run: `bundle exec rspec spec/system/home_content_spec.rb`
Expected: `2 examples, 0 failures`.

- [ ] **Step 6: Verify the full home page still renders (no regression)**

Run: `bundle exec rspec spec/system/home_content_spec.rb` and additionally load the page manually:
Run: `RAILS_ENV=test bin/rails runner 'app = ActionDispatch::Integration::Session.new(Rails.application); app.get("/en"); puts app.response.status'`
Expected: `200`.

- [ ] **Step 7: Commit**

```bash
git add app/controllers/pages_controller.rb app/views/pages/home.html.erb spec/system/home_content_spec.rb
git commit -m "feat: home view reads copy from DB sections with i18n fallback

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 12: Seed home content + first admin user

**Files:**
- Create: `lib/tasks/content.rake`, `db/seed_content/home.rb`
- Modify: `db/seeds.rb`
- Test: `spec/tasks/content_seed_spec.rb`

**Interfaces:**
- Consumes: `Section`/`Content` (Tasks 3–4), `User` (Task 6), current `config/locales/en.yml` + `ar.yml` values.
- Produces:
  - `rails content:seed` — idempotently creates the home Sections + Contents from the current copy.
  - `db/seeds.rb` creates a first admin from `ADMIN_EMAIL`/`ADMIN_PASSWORD` env (defaults for dev).

- [ ] **Step 1: Write the failing spec**

Create `spec/tasks/content_seed_spec.rb`:

```ruby
require "rails_helper"
require "rake"

RSpec.describe "content:seed", type: :task do
  before(:all) do
    Rails.application.load_tasks unless Rake::Task.task_defined?("content:seed")
  end

  before { Rake::Task["content:seed"].reenable }

  it "creates the home hero section idempotently" do
    expect { Rake::Task["content:seed"].invoke }.to change { Section.count }.by_at_least(1)
    hero = Section.for("home", "home_hero")
    expect(hero).to be_persisted
    expect(hero.text("hero_h1")).to be_present

    Rake::Task["content:seed"].reenable
    expect { Rake::Task["content:seed"].invoke }.not_to change { Section.count }
  end
end
```

- [ ] **Step 2: Run to verify it fails**

Run: `bundle exec rspec spec/tasks/content_seed_spec.rb`
Expected: FAIL — `Don't know how to build task 'content:seed'`.

- [ ] **Step 3: Create the home seed data**

Create `db/seed_content/home.rb`. Values are copied verbatim from `config/locales/en.yml` / `ar.yml` so the site is unchanged. Fill `value_ar` from `ar.yml` for each key (read those files while implementing; the example shows the shape and the hero/promise values):

```ruby
# Home page content seed. AR values from config/locales/ar.yml, EN from en.yml.
# Idempotent: upserts by (page, kind) and (section, key).
module SeedContent
  HOME = [
    {
      kind: "home_hero", label: "Hero — top of page", position: 0,
      contents: [
        { key: "hero_h1",  label: "Headline",
          en: I18n.t("home.hero_h1",  locale: :en), ar: I18n.t("home.hero_h1",  locale: :ar),
          content_type: "richtext" },
        { key: "hero_sub", label: "Sub-text under headline",
          en: I18n.t("home.hero_sub", locale: :en), ar: I18n.t("home.hero_sub", locale: :ar) }
      ]
    },
    {
      kind: "home_promise", label: "The Promise (section heading)", position: 1,
      contents: [
        { key: "label", label: "Small label",
          en: I18n.t("home.promise_label", locale: :en), ar: I18n.t("home.promise_label", locale: :ar) },
        { key: "title", label: "Heading",
          en: I18n.t("home.promise_title", locale: :en), ar: I18n.t("home.promise_title", locale: :ar) }
      ]
    },
    {
      kind: "home_founder", label: "Meet Dr. Maysa (preview)", position: 2,
      contents: [
        { key: "label", label: "Small label",
          en: I18n.t("home.founder_label", locale: :en), ar: I18n.t("home.founder_label", locale: :ar) },
        { key: "quote", label: "Pull quote",
          en: I18n.t("home.founder_quote", locale: :en), ar: I18n.t("home.founder_quote", locale: :ar) },
        { key: "body", label: "Body paragraph",
          en: I18n.t("home.founder_body", locale: :en), ar: I18n.t("home.founder_body", locale: :ar) },
        { key: "link", label: "Link text",
          en: I18n.t("home.founder_link", locale: :en), ar: I18n.t("home.founder_link", locale: :ar) }
      ]
    },
    {
      kind: "home_protocols", label: "The six protocols (heading)", position: 3,
      contents: [
        { key: "title", label: "Heading",
          en: I18n.t("home.protocols_title", locale: :en), ar: I18n.t("home.protocols_title", locale: :ar) }
      ]
    },
    {
      kind: "home_voices", label: "Patient voices (heading)", position: 4,
      contents: [
        { key: "label", label: "Small label",
          en: I18n.t("home.voice_label", locale: :en), ar: I18n.t("home.voice_label", locale: :ar) },
        { key: "title", label: "Heading",
          en: I18n.t("home.voice_title", locale: :en), ar: I18n.t("home.voice_title", locale: :ar) }
      ]
    },
    {
      kind: "home_invite", label: "Closing invitation", position: 5,
      contents: [
        { key: "label", label: "Small label",
          en: I18n.t("home.invite_label", locale: :en), ar: I18n.t("home.invite_label", locale: :ar) },
        { key: "line", label: "Invitation line",
          en: I18n.t("home.invite_line", locale: :en), ar: I18n.t("home.invite_line", locale: :ar) }
      ]
    }
  ].freeze
end
```

- [ ] **Step 4: Create the rake task**

Create `lib/tasks/content.rake`:

```ruby
namespace :content do
  desc "Seed editable Sections/Contents from current copy (idempotent)"
  task seed: :environment do
    require Rails.root.join("db/seed_content/home")

    SeedContent::HOME.each do |sec|
      section = Section.find_or_initialize_by(page: "home", kind: sec[:kind])
      section.label    = sec[:label]
      section.position = sec[:position]
      section.save!

      sec[:contents].each_with_index do |c, i|
        content = Content.find_or_initialize_by(parentable: section, key: c[:key])
        content.label        = c[:label]
        content.value_en     = c[:en]
        content.value_ar     = c[:ar]
        content.content_type = c[:content_type] || "text"
        content.position     = i
        content.save!
      end
    end

    puts "Seeded #{Section.where(page: 'home').count} home sections."
  end
end
```

- [ ] **Step 5: Add the admin-user seed**

Append to `db/seeds.rb`:

```ruby
# First admin. Override with ADMIN_EMAIL / ADMIN_PASSWORD env vars.
admin_email = ENV.fetch("ADMIN_EMAIL", "admin@neuskin.test")
User.find_or_create_by!(email: admin_email) do |u|
  u.password = ENV.fetch("ADMIN_PASSWORD", "changeme123")
  u.role     = "admin"
end

# Content sections.
Rake::Task["content:seed"].invoke if Rake::Task.task_defined?("content:seed")
```

- [ ] **Step 6: Run the seed spec**

Run: `bundle exec rspec spec/tasks/content_seed_spec.rb`
Expected: `1 example, 0 failures`.

- [ ] **Step 7: Seed dev and verify the home page is unchanged**

Run: `bin/rails content:seed`
Expected: prints "Seeded 6 home sections."

Run: `bin/rails runner 'app = ActionDispatch::Integration::Session.new(Rails.application); app.get("/en"); puts app.response.status'`
Expected: `200`, and the seeded values equal the i18n values (so no visual change).

- [ ] **Step 8: Commit**

```bash
git add lib/tasks/content.rake db/seed_content/ db/seeds.rb spec/tasks/
git commit -m "feat: content:seed rake task + admin user seed for home page

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 13: End-to-end system test (edit in admin → see on site)

**Files:**
- Test: `spec/system/admin_edits_home_spec.rb`

**Interfaces:**
- Consumes: everything above. This is the proof that the whole loop works for a non-technical editor.

- [ ] **Step 1: Write the end-to-end system spec**

Create `spec/system/admin_edits_home_spec.rb`:

```ruby
require "rails_helper"

RSpec.describe "Editing the home page from admin", type: :system do
  it "changes the live home headline" do
    admin   = create(:admin_user)
    section = create(:section, page: "home", kind: "home_hero", label: "Hero")
    create(:content, parentable: section, key: "hero_h1", label: "Headline",
           value_en: "Original headline", value_ar: "العنوان")

    sign_in admin

    visit admin_section_path(section)
    expect(page).to have_content("Headline")           # friendly label, not "hero_h1"
    fill_in "English", with: "Brand new headline", match: :first
    click_button "Save"
    expect(page).to have_content("Saved.")

    visit root_path(locale: "en")
    expect(page).to have_content("Brand new headline")
  end
end
```

- [ ] **Step 2: Run it**

Run: `bundle exec rspec spec/system/admin_edits_home_spec.rb`
Expected: `1 example, 0 failures`. (The hero view uses `sec_text(...).presence || t(...)`, so the DB value now wins.)

- [ ] **Step 3: Run the whole suite**

Run: `bundle exec rspec`
Expected: all green.

- [ ] **Step 4: Commit**

```bash
git add spec/system/admin_edits_home_spec.rb
git commit -m "test: end-to-end admin edit reflects on live home page

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

## Self-Review

**Spec coverage:**
- Architecture (same-app admin, DB-read public) → Tasks 3–5, 7, 11. ✓
- Hybrid model (Content rows / JSONB items / settings / images) → Tasks 3, 4, 10. ✓
- Devise auth + roles → Task 6; guard → Task 7. ✓
- Admin routing/screens (dashboard, pages, sections) → Tasks 7, 8, 9, 10. ✓
- User-friendliness §6.1 (friendly labels, pages in order, EN/AR side by side, image preview, success flash, "View this page") → Tasks 9, 10, 13. `label`/`hint` columns Task 4; asserted in Tasks 10 & 13. ✓
- Public rewiring + helpers + fallback → Tasks 5, 11. ✓
- Seed (no visual change) → Task 12. ✓
- Testing (RSpec model/helper/request/system) → every task. ✓
- **Deferred to later plans (documented):** remaining 13 pages (repeat Task 11 pattern), first-class collections (Protocol CRUD, JournalPost, Inquiry status/inbox, BridalLead export, media library, users admin), and the card-based repeating-item editor (currently JSON textarea, Task 10 Step 6). These are increments 3–5 in spec §10 and get their own plans.

**Placeholder scan:** No "TBD"/"handle appropriately". The one place values are read while implementing (AR strings in Task 12) uses `I18n.t(..., locale: :ar)` so no manual transcription is needed. ✓

**Type consistency:** `Section.for(page, kind)`, `Section#text(key)`, `Content#value`, `sec_text/sec_items/sec_image`, `SitePages.name_for` — names identical across Tasks 3, 4, 5, 9, 10, 11, 12. ✓

**Note for implementer:** `skip_around_action :switch_locale` in Task 7 assumes the callback name in `ApplicationController`; it is `switch_locale` (verified). If system tests for JS interactions are needed later, swap `driven_by :rack_test` for `:selenium_chrome_headless` — rack_test is sufficient for this plan (no JS assertions).
