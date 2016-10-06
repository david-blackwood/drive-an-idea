# Ideas Controller
class IdeasController < ApplicationController
  before_action :set_idea, only: [:show, :edit, :update, :destroy]

  # GET /ideas
  # GET /ideas.json
  def index
    @search = Idea.ransack(params[:q])
    @ideas = @search.result
  end

  def open_ideas
    @search = Idea.all.ransack(params[:q])
    @ideas = @search.result.select { |idea| idea.open? }
  end

  # GET /ideas/1
  # GET /ideas/1.json
  def show
    @current_user == current_user
  end

  # GET /ideas/new
  def new
    @idea = Idea.new
  end

  # GET /ideas/1/edit
  def edit
    authorize! :update, @idea
  end

  # POST /ideas
  # POST /ideas.json
  def create
    @idea = Idea.new(idea_params)
    @idea.user = current_user

    respond_to do |format|
      if @idea.save
        format.html {
          redirect_to @idea, notice: 'Idea was successfully created.'
        }
        format.json { render :show, status: :created, location: @idea }
      else
        format.html { render :new }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ideas/1
  # PATCH/PUT /ideas/1.json
  def update
    authorize! :update, @idea
    respond_to do |format|
      if @idea.update(idea_params)
        format.html {
          redirect_to @idea, notice: 'Idea was successfully updated.'
        }
        format.json { render :show, status: :ok, location: @idea }
      else
        format.html { render :edit }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ideas/1
  # DELETE /ideas/1.json
  def destroy
    authorize! :destroy, @idea
    @idea.destroy
    respond_to do |format|
      format.html {
        redirect_to ideas_url, notice: 'Idea was successfully destroyed.'
      }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_idea
    @idea = Idea.find(params[:id])
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def idea_params
    params.require(:idea).permit(:text, :user_id, :voting_style,
                                 :anonymous_comments, :real_time_voting,
                                 :reveal_voter_details, :open_days)
  end
end
