class RegistrationsController < ApplicationController
  before_filter :authenticate_participant!, only: [:create, :check]
  def create
    @event = Event.find_by_id(params[:id])
    if @event
      if @event.registered? current_participant
        respond_to do |format|
          format.html{redirect_to fallback_redirect}
          format.json{
            render json: {data: "Already Registered"}
          }
        end
      else
        if @event.team_event?
          if params[:team_code].present?
            @team = Team.find_by_tid(params[:team_code])
            if @team
              @participant_team = ParticipantTeam.create(team: @team, participant: current_participant)
              if @participant_team
                team_code = "You have "+@team.participants.count.to_s + " team members. Add more team members by using team code: " + @team.tid.to_s
                respond_to do |format|
                  format.html{redirect_to fallback_redirect}
                  format.json{render json: {data: "Success", extra_data: team_code,team_code: @team.tid.to_s,team_size: @team.participants.count}}
                end
              else
                respond_to do |format|
                  format.html{redirect_to fallback_redirect}
                  format.json{render json: {data: "Failure", extra_data: "Error creating registration"}}
                end
              end
            else
              respond_to do |format|
                format.html{redirect_to fallback_redirect}
                format.json{render json: {data: "Failure", extra_data: "Invalid Team Code."}}
              end
            end
          elsif params[:team_name].present?
            @team = Team.create(event: @event, team_name: params[:team_name])
            if @team
              @participant_team = ParticipantTeam.create(team: @team, participant: current_participant)
              if @participant_team
                team_code = "You have "+@team.participants.count.to_s + " team members. Add more team members by using team code: " + @team.tid.to_s
                respond_to do |format|
                  format.html{redirect_to fallback_redirect}
                  format.json{render json: {data: "Success", extra_data: team_code,team_code: @team.tid.to_s,team_size: @team.participants.count}}
                end
              else
                respond_to do |format|
                  format.html{redirect_to fallback_redirect}
                  format.json{render json: {data: "Failure", extra_data: "Error creating registration"}}
                end
              end
            else
              respond_to do |format|
                format.html{redirect_to fallback_redirect}
                format.json{render json: {data: "Failure", extra_data: "Error creating team."}}
              end
            end
          else
            respond_to do |format|
              format.html{redirect_to fallback_redirect}
              format.json{render json: {data: "Failure", extra_data: "Something went wrong."}}
            end
          end
        else
          registration = Registration.create(event: @event, participant: current_participant)
          if registration
            respond_to do |format|
              format.html{redirect_to fallback_redirect}
              format.json{render json: {data: "Success"}}
            end
          else
            respond_to do |format|
              format.html{redirect_to fallback_redirect}
              format.json{render json: {data: "Failure"}}
            end
          end
        end
      end
    else
      respond_to do |format|
        format.html{
          redirect_to root_url
        }
        format.json{
          render json: {data: "Invalid event"}
        }
      end
    end
  end

  def check
    @event = Event.find_by_id(params[:id])
    registered?(@event)
  end

  def new
    @events = Event.all
  end


  # TODO: Also, you'd need to check authorization header for auth_token you
  # send in requests that matter
  def send_auth_token_to_mobile_app_temp
    # Save and verify and handle the incoming GoogleUserApiKey
    respond_to do |format|
      format.html{redirect_to fallback_redirect}
      format.json{render json: {auth_token: "62442"}}
  end

  def register_GCM_token_temp
    respond_to do |format|
      format.html{redirect_to fallback_redirect}
      format.json{render json: {success: true}}
  end

  def new_event
    @event = Event.find_by_id(params[:id])
  end

  def create_form
    asd
  end
end