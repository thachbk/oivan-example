class ApplicationController < ActionController::Base
  # include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :authenticate_user!

  rescue_from ActionView::MissingTemplate, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from CanCan::AccessDenied, with: :access_denied

  def index
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || admin_users_path || super
  end

  def after_sign_out_path_for(_resource_or_scope)
    :new_user_session
  end

  def render_404
    respond_to do |format|
      format.html { render 'home/page_not_found', status: 404 }
      format.json { render_404_json }
    end
  end

  def render_404_json
    render json: { error: '404 Page not found' }, status: 404
  end

  def access_denied(exception)
    sign_out_and_redirect(current_user)
    flash[:alert] = exception.message.to_s
  end

  def authenticate_admin_user!
    authenticate_user!
    raise CanCan::AccessDenied.new("User Access Denied!") unless current_user&.teachers?
  end
end
