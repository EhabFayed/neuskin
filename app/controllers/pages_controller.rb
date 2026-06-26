class PagesController < ApplicationController
  def home
  end

  def dr_maysa
  end

  def the_team
  end

  def the_clinic
  end

  def journal
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
