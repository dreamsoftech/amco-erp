class EventsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin_authorization, except: ["index"]

	def index
    @from = Date.parse(params[:from]) unless params[:from].nil? or params[:from] == ""
    @to = Date.parse(params[:to]) unless params[:to].nil? or params[:to] == ""

    if !@from.nil? && !@to.nil?
    	range = @from..@to
  		@events = Event.where(created_at: range).paginate(page: params[:page], per_page: 10)
  	elsif !@from.nil?
  		@events = Event.where("created_at > ?", @from).paginate(page: params[:page], per_page: 10)
  	elsif !@to.nil?
  		@events = Event.where("created_at < ?", @to).paginate(page: params[:page], per_page: 10)
  	else
  		@events = Event.paginate(page: params[:page], per_page: 10)
		end

		cookies[:from] = params[:from]
		cookies[:to] = params[:to]

    if @events.empty?
      events_path notice: "There is no logged event."
    end
  end

end
