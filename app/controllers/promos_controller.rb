# NeuSkin Digital Gift Card — the campaign page (/promo). A standalone
# phone-sized experience (own layout, no site chrome): a closed envelope,
# one tap opens it, the gift card rises out with the offer and a WhatsApp
# reserve button. Promo rows come from the dashboard (Admin → Promos).
class PromosController < ApplicationController
  layout "promo"

  # claim is a fire-and-forget beacon from the page's own JS; it carries the
  # CSRF token when it can, but a stale token must never block the count.
  skip_before_action :verify_authenticity_token, only: :claim

  # /promo shows the first live gift; /promo/GLOW25 a specific one (each promo
  # has its own link in the dashboard). A gift that is off or used up falls
  # back to whatever is live, so an old link never dead-ends.
  def show
    @promo = Promo.available.find_by(code: params[:code].to_s.upcase) if params[:code].present?
    @promo ||= Promo.available.first
  end

  # One tap on the reserve button = one use. Called by envelope_controller.js
  # (fetch, keepalive) right before the wa.me link opens. Counting is
  # best-effort: the link opens whether or not this request lands.
  def claim
    promo = Promo.unscoped.find_by(code: params[:code].to_s.upcase)
    return head :not_found if promo.nil?

    if promo.claim!
      render json: { ok: true, remaining: promo.remaining_uses }
    else
      render json: { ok: false, remaining: 0 }, status: :conflict
    end
  end
end
