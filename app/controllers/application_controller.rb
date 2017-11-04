class ApplicationController < ActionController::Base
  #protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  before_action :set_locale_from_browser

  def set_locale_from_browser
    if (session[:initialized].nil? || !session[:initialized])
      logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
      I18n.locale = extract_locale_from_accept_language_header
      logger.debug "* Locale set to '#{I18n.locale}'"
    else
      logger.info "* Locale already set to '#{I18n.locale}'"
      endsession[:initialized] = true
    end
  end


  private

  def extract_locale_from_accept_language_header
    language = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    logger.debug language
    if language != "de"
      return "en"
    else
      return language
    end
  end

end
