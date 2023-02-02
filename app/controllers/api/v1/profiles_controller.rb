class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    render json: current_resource_owner
  end

  def others
    @users = User.where.not(id: current_resource_owner)
    render json: @users
  end
end