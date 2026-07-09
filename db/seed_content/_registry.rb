# Shared registry every per-page seed file appends to. Loaded first
# (underscore sorts before letters). Each page file calls:
#   SeedContent.register("dr_maysa", [ { kind:, label:, position:, contents: [...] }, ... ])
module SeedContent
  @pages = {}
  class << self
    attr_reader :pages
    def register(page, sections) = (@pages[page.to_s] = sections)
    def reset! = (@pages = {})
  end
end
