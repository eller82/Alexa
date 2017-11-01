class Pvoutput::V1::PvoutputController < ApplicationController

#Api::V1::PostsController

  require 'alexa_rubykit'
  require 'net/http'
  require 'uri'

  def index

    # Check that it's a valid Alexa request
    request_json = JSON.parse(request.body.read.to_s)
    # Creates a new Request object with the request parameter.
    request = AlexaRubykit.build_request(request_json)

    session = request.session


    # generates the output
    response = AlexaRubykit::Response.new
    session_end = true

    # Response
    # If it's a launch request
    if (request.type == 'LAUNCH_REQUEST')
      # Process your Launch Request
      # Call your methods for your application here that process your Launch Request.
      response.add_speech('Ruby running ready!')
      response.add_hash_card( { :title => 'Ruby Run', :subtitle => 'Ruby Running Ready!' } )
    end

    if (request.type == 'INTENT_REQUEST')
      # Process your Intent Request
      p "#{request.slots}"
      p "#{request.name}"
      #pvoutput = Net::HTTP.get_response("https://pvoutput.org/service/r2/getstatus.jsp","key=d890b26df0e774786a07698ee43256fa16bbefef&sid=43733")
      #puts pvoutput.body

      uri = URI.parse('https://pvoutput.org/service/r2/getstatus.jsp?key=d890b26df0e774786a07698ee43256fa16bbefef&sid=43733')
      #uri = URI.parse("http://www.google.com")
      pvoutput = Net::HTTP.get_response(uri)
      puts pvoutput.body

      pv_result = Array.new
      pv_result = pvoutput.body.split(',')

      puts pv_result
      kilowatt = pv_result[2].to_d/1000

      #response.add_speech("I received an intent named #{request.name}?")
      response.add_speech("Du hast bisher #{kilowatt.round(2)} Kilowatt Stunden generiert.")

      response.add_hash_card( { :title => 'Ruby Intent', :subtitle => "Intent #{request.name}" } )
    end

    if (request.type =='SESSION_ENDED_REQUEST')
      # Wrap up whatever we need to do.
      p "#{request.type}"
      p "#{request.reason}"
      halt 200
    end

    #output.add_speech("Du hast heute 42 Kilowatt Stunden generiert.")
    render json: response.build_response(session_end)

  end

  #https://pvoutput.org/service/r2/getstatus.jsp?key=d890b26df0e774786a07698ee43256fa16bbefef&sid=43733

end
