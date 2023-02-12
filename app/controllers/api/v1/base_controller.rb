class Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!

  protect_from_forgery with: :null_session

  private

  def current_user
    if doorkeeper_token
      return current_resource_owner
    end
    # fallback to auth with warden if no doorkeeper token
    warden.authenticate(:scope => :user)
  end

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end