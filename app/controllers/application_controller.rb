class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from StripeService::StripeConfigurationError, with: :stripe_configuration_error

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :first_name, :last_name, :description ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :first_name, :last_name, :description ])
  end

  def record_not_found
    redirect_to root_path, alert: "Ressource introuvable"
  end

  def stripe_configuration_error
    redirect_to root_path, alert: "Configuration de paiement manquante. Contactez l'administrateur."
  end

  def stripe_session_error(exception)
    redirect_back(fallback_location: root_path, alert: "Erreur de paiement: #{exception.message}")
  end
end
