class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super

    #store data from Amazon into a session for later handover
    session[:client_id] = params[:client_id]
    session[:response_type] = params[:response_type]
    session[:state] = params[:state]
    session[:redirect] = params[:redirect_uri]

  end

  # POST /resource
  def create
     super

     # if the new user got create also store Amazon Information
     if resource.save

       #save Amazon Information
       alexa = Amazon.new

       #alexa.UniqueID = #TODO
       alexa.UserID = resource.id
       alexa.AlexaID = session[:state]

       alexa.save

       #if alexa.save
         #redirect_to session[:redirect] + '#access_token=' + resource.token + '&state=' + session[:state] + '&token_type=Bearer'
         #https://subdomain.amazon.com/spa/skill/account-linking-status.html?vendorId=W5TGH673R#access_token=something-I-made-up&state=same_long_string&token_type=Bearer
       #end

     end

  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
     #super(resource)
     session[:redirect] + '#access_token=' + resource.token + '&state=' + session[:state] + '&token_type=Bearer'
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
