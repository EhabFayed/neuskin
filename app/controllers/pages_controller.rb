class PagesController < ApplicationController
  def home
    @sections = Section.where(page: "home").includes(:contents).index_by(&:kind)
  end

  def dr_maysa
  end

  def the_team
    @members = TeamMember.with_attached_photo
  end

  def the_clinic
  end

  def stories
  end

  def faq
  end

  def maysa_method
  end

  # Treatments — browse by outcome (design §08).
  def treatments
  end

  # One outcome page (design §08 "Outcome" screen). Each outcome is owned by
  # a single protocol — the map mirrors the design's OUT data.
  TREATMENT_OUTCOME_OWNERS = {
    "skin"        => "90-day-glow-reset",
    "hair"        => "reset-crown",
    "body"        => "8-week-sculpt",
    "injectables" => "maysa-method",
    "devices"     => "maysa-method"
  }.freeze

  def treatment_outcome
    @outcome  = params[:outcome]
    @protocol = Protocol.find_by(slug: TREATMENT_OUTCOME_OWNERS.fetch(@outcome))
  end

  def private_care
  end

  # Legal & compliance (§15). Each renders the shared legal layout with a
  # different i18n key namespace. Copy is draft — pending KSA legal review.
  def privacy
    render :legal, locals: { doc: "privacy" }
  end

  def medical_disclaimer
    render :legal, locals: { doc: "medical_disclaimer" }
  end

  def terms
    render :legal, locals: { doc: "terms" }
  end
end
