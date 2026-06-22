class InquiryNotificationJob < ApplicationJob
  queue_as :default

  # STUB: notify the patient-relations lead of a new inquiry.
  # Wire to email / WhatsApp Business API later (architecture §11 SLA: < 2h).
  def perform(inquiry_id)
    inquiry = Inquiry.find_by(id: inquiry_id)
    return unless inquiry

    Rails.logger.info("[InquiryNotification] New inquiry ##{inquiry.id} from #{inquiry.name} (#{inquiry.mobile})")
  end
end
