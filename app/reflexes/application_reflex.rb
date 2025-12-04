# frozen_string_literal: true

class ApplicationReflex < StimulusReflex::Reflex
  # Put application-wide Reflex behavior and callbacks in this file.
  #
  # Learn more at: https://docs.stimulusreflex.com/rtfm/reflex-classes

  delegate :current_user, to: :connection

  before_reflex do
    ActsAsTenant.current_tenant = current_user&.account
    Current.account = current_user&.account
  end

  #
  # If you need to localize your Reflexes, you can set the I18n locale here:
  #
  #   before_reflex do
  #     I18n.locale = :fr
  #   end
  #
  # For code examples, considerations and caveats, see:
  # https://docs.stimulusreflex.com/rtfm/patterns#internationalization
end
