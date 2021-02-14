class SettingsController < ApplicationController
    before_action :authenticate_user!

    def profile
        @project = Project.first
    end

    def password
        @resource = current_user
    end

    def notifications

    end
end
