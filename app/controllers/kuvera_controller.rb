class KuveraController < ApplicationController

  def index
    @schemes = Scheme.all
    @purchased_schemes = JSON.parse(session[:persistent_data]) if session[:persistent_data].present?
    @investment = Scheme.calculate_investment(@purchased_schemes)
    @return = Scheme.calculate_return(@purchased_schemes)
  end

  def create
  	if params[:code].present? && params[:date].present? && params[:amount].present?
      if session[:persistent_data].present?
        temp = JSON.parse(session[:persistent_data])
        temp << {:code => params[:code], :date => params[:date], :amount => params[:amount]}
        session[:persistent_data] = temp.to_json
      else
        session[:persistent_data] = [{:code => params[:code], :date => params[:date], :amount => params[:amount]}].to_json
      end
    end
  	redirect_to :back
  end

  def clear_session
  	session[:persistent_data] = nil
  	redirect_to :back
  end
  
end
