class LandingsController < ApplicationController
  layout :resolve_layout
  def index
  end
  def home
  end
  def mhome
  end
  def coming_soon
  end

  private

  def resolve_layout
    case action_name
    when "index", "mhone"
      "application"
    when "home"
      "ide"
    when "coming_soon"
      "cs"
    else
      "application"
    end
  end
end
