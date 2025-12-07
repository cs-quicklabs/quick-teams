class AccountNotificationReflex < ApplicationReflex
  def toggle_email_notification
    account = Account.find(element.dataset[:id])
    account.update(email_enabled: !account.email_enabled)
    morph "#account-email-notification", render(partial: "account/preferences/email_notification", locals: { account: account })
  end
end
