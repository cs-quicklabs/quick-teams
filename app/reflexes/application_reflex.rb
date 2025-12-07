# frozen_string_literal: true

class ApplicationReflex < StimulusReflex::Reflex
  delegate :current_user, to: :connection

  before_reflex do
    ActsAsTenant.current_tenant = current_user&.account
    Current.account = current_user&.account
  end
end
