class MoviesController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_movie, only: [:show, :edit, :update, :destroy]
  before_action :set_movie_public, only: [:react_to_movie]

  # GET /movies
  # GET /movies.json
  def index
    order_by = params[:order_by]
    order_direction = ['DESC', 'ASC'].include?(params[:order]) ? params[:order] : "DESC"
    if params[:movies_by_user_id] 
      @movies = User.find(params[:movies_by_user_id]).movies
    else
      @movies = Movie.all
    end

    if order_by == "likes"
      @movies = @movies.left_outer_joins(:movie_reactions).select('movies.*, (Select count(*) from movie_reactions WHERE movie_id = movies.id AND liked = TRUE ) AS likes').group('movies.id').order("likes #{order_direction}")
    elsif order_by == "hates"
      @movies = @movies.left_outer_joins(:movie_reactions).select('movies.*, (Select count(*) from movie_reactions WHERE movie_id = movies.id AND liked = FALSE ) AS hates').group('movies.id').order("hates #{order_direction}")
    elsif order_by == "date"
      @movies = @movies.order("created_at #{order_direction}")
    end

    @movies = @movies.page movie_params[:page]
  end

  # GET /movies/1
  # GET /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies
  # POST /movies.json
  def create
    @movie = current_user.movies.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to movies_path, notice: 'Movie was successfully created.' }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1
  # PATCH/PUT /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to edit_movie_path(@movie), notice: 'Movie was successfully updated.' }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    @movie.destroy
    respond_to do |format|
      format.html { redirect_to movies_url, notice: 'Movie was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def react_to_movie
    reaction = current_user.movie_reactions.find_by(movie_id: @public_movie.id)
    @action_to_do = params[:reaction]

    if (@action_to_do == "remove")
      reaction.destroy if reaction
    elsif reaction.nil?
      reaction = current_user.movie_reactions.new(movie_id: @public_movie.id)
    end

    if (@action_to_do == "like")
      reaction.liked = true
      reaction.save!
    elsif (@action_to_do == "hate")
      reaction.liked = false
      reaction.save!
    end

    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie_public
      @public_movie = Movie.find(params[:id])
    end

    def set_movie
      @movie = current_user.movies.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movie_params
      params.permit(:title, :description, :order_by, :order, :movies_by_user_id, :reaction, :search, :page)
    end
end
