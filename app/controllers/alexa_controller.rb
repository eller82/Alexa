class AlexaController < ApplicationController

  before_action :authenticate_user!

  def index

    solar = Pvoutput.find_by UserID: current_user.id

    if solar
      @pvoutput = solar
    else
      @pvoutput = Pvoutput.new
    end

  end

  def savePVoutput

    #create a new entry or update existing data 
    Pvoutput.
      find_or_initialize_by(:UserID => current_user.id).
      update_attributes!(:key => params[:pvoutput][:key],
                         :sid => params[:pvoutput][:sid])

    redirect_to root_path
  end

end
