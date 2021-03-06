# == Schema Information
#
# Table name: invitations
#
#  aasm_state           :string
#  code_of_conduct      :boolean          default(FALSE)
#  created_at           :datetime         not null
#  delivered            :boolean          default(FALSE)
#  id                   :integer          not null, primary key
#  invitee_company      :string
#  invitee_email        :string
#  invitee_introduction :text
#  invitee_location     :string
#  invitee_name         :string
#  invitee_title        :string
#  medium               :string
#  member_application   :boolean          default(FALSE)
#  registered           :boolean          default(FALSE)
#  retries              :integer          default(0)
#  slack_uid            :string
#  updated_at           :datetime         not null
#  user_id              :integer
#
# Indexes
#
#  index_invitations_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class CodeOfConductValidator < ActiveModel::Validator
  def validate(record)
    if record.code_of_conduct == false
      record.errors[:base] << "Please accept our Code of Conduct to proceed"
    end
  end
end

class Invitation < ApplicationRecord
  include AASM

  aasm do
    state :not_sent, :initial => true
    state :sent
    state :resent
    state :accepted
    state :revoked

    event :send_invite do
      transitions :from => [:not_sent], :to => :sent
      success do
        process_invitation
      end
    end

    event :resend_invite do
      transitions :from => [:not_sent, :sent, :resent], :to => :resent
      success do
        resend_invitation
      end
    end
  end

  after_create :new_invite_notify_administrators

  belongs_to :user

  # TODO: DRY up boolean method
  validates :invitee_email, presence: true, unless: Proc.new { |member| member.member_application == true }
  validates :invitee_email, uniqueness: true, unless: Proc.new { |member| member.member_application == true }
  validates :invitee_name, presence: true, unless: Proc.new { |member| member.member_application == true }
  validates :invitee_email, email: true

  validates_with CodeOfConductValidator

  scope :all_sent, ->(user_id) { where("user_id = ?", user_id) }

  def self.has_pending_invitation_to_join_slack(email)
    where(invitee_email: email).exists?
  end

  def invitee_location_name
    if self.invitee_location?
      country = ISO3166::Country[self.invitee_location]
      country.translations[I18n.locale.to_s] || country.name
    else
      'Lebanon'
    end
  end

  def process_invitation
    process_invitation_on_slack
  end

  def resend_invitation
    increment!(:retries)
    resend_invite_notify_administrators
    process_invitation_on_slack
  end

  def location_name
    unless invitee_location.blank?
      country = ISO3166::Country[invitee_location]
      (country.translations[I18n.locale.to_s] || country.name) if country
    else
      "Not set"
    end
  end

  private
    def new_invite_notify_administrators
      InvitationMailer.new_slack_invitation(self.id).deliver
    end

    def resend_invite_notify_administrators
      InvitationMailer.resend_slack_invitation(self.id).deliver
    end

    def process_invitation_on_slack
      unless self.invitee_email.blank?
        begin
          response = SlackApi.send_invitation(self.invitee_email)
          return response
        rescue Exception => e
          logger.error(e)
        end
      end
    end
end
