class InquiriesController < ApplicationController
  def new
    @inquiry = Inquiry.new(source_codeword: params[:codeword], persona: params[:persona])
  end

  def create
    @inquiry = Inquiry.new(inquiry_params)
    @inquiry.preferred_locale ||= I18n.locale.to_s

    if @inquiry.save
      InquiryNotificationJob.perform_later(@inquiry.id)
      # Per the chosen flow: save, then hand the patient straight to WhatsApp
      # with their codeword prefilled. allow_other_host for the wa.me redirect.
      wa = Clinic.whatsapp_url(text: t("whatsapp.prefill"), codeword: @inquiry.source_codeword)
      redirect_to wa, allow_other_host: true
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(
      :name, :mobile, :email, :preferred_locale, :persona, :preferred_time, :source_codeword
    )
  end
end
