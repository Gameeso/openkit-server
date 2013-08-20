class BestScoresController < ApplicationController
  before_filter :require_api_access
  before_filter :set_leaderboard

  # Note:
  # The overriden method User#as_json does not get called when ':include => :user'
  # is passed to Score#as_json.
  def index
    x = params.delete(:page_num)
    y = params.delete(:num_per_page)
    @scores = Score.bests_for(params[:leaderboard_range], @leaderboard.id, {page_num: x, num_per_page: y})
    ActiveRecord::Associations::Preloader.new(@scores, [:user]).run
    json_arr = @scores.as_json(:include => :user, :methods => [:value, :rank])
    json_arr.each {|obj| ApiMolding.fb_fix_0_9(obj)}
    render json: json_arr
  end

  def user
    @score = Score.best_for(params[:leaderboard_range], @leaderboard.id, params[:user_id])
    ActiveRecord::Associations::Preloader.new(@score, [:user]).run
    json = @score.as_json(:include => :user, :methods => [:value, :rank])
    ApiMolding.fb_fix_0_9(json)
    render json: json
  end

  def social
    @scores = Score.social(authorized_app, @leaderboard, params[:fb_friends])
    json_arr = @scores.as_json(:include => :user, :methods => [:value, :rank])
    json_arr.each {|obj| ApiMolding.fb_fix_0_9(obj)}
    render json: json_arr
  end

  private
  def set_leaderboard
    @leaderboard = authorized_app.leaderboards.find_by_id(params.delete(:leaderboard_id))
    unless @leaderboard
      render status: :forbidden, json: {message: "Pass a leaderboard_id that belongs to the app associated with app_key"}
    end
  end
end
