class Pvoutput::V1::PvoutputController < ApplicationController

  skip_before_action :set_locale_from_browser

  require 'alexa_rubykit'
  require 'net/http'
  require 'uri'

  def index

    # Check that it's a valid Alexa request
    request_json = JSON.parse(request.body.read.to_s)
    # Creates a new Request object with the request parameter.
    request = AlexaRubykit.build_request(request_json)

    session = request.session
    #session.user['accessToken']

    # generates the output
    response = AlexaRubykit::Response.new
    session_end = true

    # Response
    # If it's a launch request
    if (request.type == 'LAUNCH_REQUEST')
      # Process your Launch Request
      # Call your methods for your application here that process your Launch Request.
      if getBasicInformation(session.user['accessToken'])

        uri = URI.parse("https://pvoutput.org/service/r2/getstatus.jsp?key=#{@@pv_key}&sid=#{@@pv_sid}")
        pvoutput = Net::HTTP.get_response(uri)

        pv_result = Array.new
        pv_result = pvoutput.body.split(',')

        kilowatt = pv_result[2].to_d/1000

        @@subtitle = "generierter Strom"
        @@message = "Du hast bisher #{kilowatt.round(2)} Kilowatt Stunden generiert."

        response.add_speech(@@message)
        response.add_hash_card( { :title => "PVoutput", :subtitle => @@subtitle, :content => @@message } )

      end
    end

    if (request.type == 'INTENT_REQUEST')
      # Process your Intent Request
      #p "#{request.slots}"
      #p "#{request.name}"

      if getBasicInformation(session.user['accessToken'])
        case request.name
        when "getPVoutputGeneration"
          uri = URI.parse("https://pvoutput.org/service/r2/getstatus.jsp?key=#{@@pv_key}&sid=#{@@pv_sid}")
          pvoutput = Net::HTTP.get_response(uri)

          pv_result = Array.new
          pv_result = pvoutput.body.split(',')

          kilowatt = pv_result[2].to_d/1000

          @@subtitle = "generierter Strom"
          @@message = "Du hast bisher #{kilowatt.round(2)} Kilowatt Stunden generiert."
        when "getPVoutputUsage"
          uri = URI.parse("https://pvoutput.org/service/r2/getstatus.jsp?key=#{@@pv_key}&sid=#{@@pv_sid}")
          pvoutput = Net::HTTP.get_response(uri)

          pv_result = Array.new
          pv_result = pvoutput.body.split(',')

          kilowatt = pv_result[4].to_d/1000

          @@subtitle = "verbrauchter Strom"
          @@message = "Du hast bisher #{kilowatt.round(2)} Kilowatt Stunden verbraucht."
        else
          @@subtitle = "ein Fehler ist aufgetreten"
          @@message = "Ich verstehe dich leider nicht."
        end
      else
        @@subtitle = "ein Fehler ist aufgetreten"
      end

      response.add_speech(@@message)
      response.add_hash_card( { :title => "PVoutput", :subtitle => @@subtitle, :content => @@message } )

    end

    if (request.type =='SESSION_ENDED_REQUEST')
      # Wrap up whatever we need to do.
      p "#{request.type}"
      p "#{request.reason}"
      halt 200
    end

    render json: response.build_response(session_end)

  end

  protected

  def getBasicInformation(accessToken)
    #check if User exists and if Pvoutput.org Information is available
    if not checkUser(accessToken)
      @@message = "Benutzer nicht vorhanden, bitte zuerst mit Alexa App verbinden."
      return false
    else
      if not getPvoutput(@@userID)
        @@message = "Pvoutput.org Daten noch nicht hinterlegt. Bitte melde dich bei https://alexa.mellentin.eu mit deinem Benutzername an und hinterlege deine Zugriffsdaten. Den Link siehst du jetzt auch in deiner Alexa App."
        return false
      else
        return true
      end
    end
  end

  #check if user exists
  def checkUser(userToken)

    user = User.find_by_token(userToken)

    if user
      @@userID = user.id
      return true
    else
      return false
    end
  end

  #get pvoutput values
  def getPvoutput(userID)

    solar = Pvoutput.find_by UserID: userID

    if solar
      @@pv_sid = solar.sid
      @@pv_key = solar.key
      return true
    else
      return false
    end

  end

end
