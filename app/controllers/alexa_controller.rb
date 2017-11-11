class AlexaController < ApplicationController

  require 'net/http'
  require 'uri'

  before_action :authenticate_user!, :except => [:privacy]

  def index

    if not session[:redirect].blank?

      redirect_to session[:redirect] + '#access_token=' + current_user.token + '&state=' + session[:state] + '&token_type=Bearer'

    else

      solar = Pvoutput.find_by user_id: current_user.id

      if solar
        @pvoutput = solar
      else
        @pvoutput = Pvoutput.new
      end
    end

  end

  #Save PVOutput information to the Database
  def savePVoutput

    #create a new entry or update existing data
    Pvoutput.
      find_or_initialize_by(:user_id => current_user.id).
      update_attributes!(:key => params[:pvoutput][:key],
                         :sid => params[:pvoutput][:sid])

    redirect_to root_path
  end

  #pvoutputtest
  def pvoutputtest

    @@pv_key = params[:key]
    @@pv_sid = params[:sid]

    uri = URI.parse("https://pvoutput.org/service/r2/getstatus.jsp?key=#{@@pv_key}&sid=#{@@pv_sid}")
    #logger.info uri
    pvoutput = Net::HTTP.get_response(uri)


    if pvoutput.code == "200"
      @pvoutputtest = true
      @pv_result = Array.new
      @pv_result = pvoutput.body.split(',')
      #kilowatt = pv_result[2].to_d/1000
    else
      @pvoutputtest = pvoutput.message
    end

    respond_to do |format|
        format.js
    end

  end

  #just render the privacy html file
  def privacy

  end

end
