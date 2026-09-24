# Shared registry every per-page seed file appends to. Loaded first
# (underscore sorts before letters). Each page file calls:
#   SeedContent.register("dr_maysa", [ { kind:, label:, position:, contents: [...] }, ... ])
module SeedContent
  @pages = {}
  class << self
    attr_reader :pages
    # Appends, so one file may add sections to a page another file registered
    # (db/seed_content/seo.rb adds the "Search preview" section to every page).
    def register(page, sections) = ((@pages[page.to_s] ||= []).concat(sections))
    def reset! = (@pages = {})
  end
end
