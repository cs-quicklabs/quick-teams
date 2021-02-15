class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account

  def profile
  end

  def roles
  end

  def clients
  end

  def peopletags
  end

  def projecttags
  end

  def disciplines
  end

  def skills
  end

  def peoplestatus
  end

  def projectstatus
  end

  private

  def set_account
    @account = current_user.account
  end
end
