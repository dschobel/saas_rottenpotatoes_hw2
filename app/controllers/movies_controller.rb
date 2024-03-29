class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def get_missing_params_from_session(symbol)
    if nil == params[symbol] && session[symbol]
      return params.merge(symbol => session[symbol])
    else 
      return {}
    end
  end

  def index
    #ActiveRecord::Base.logger = Logger.new STDOUT
    @all_ratings = Movie::RATINGS

    new_params = {}
    new_params.merge! get_missing_params_from_session(:sort)
    new_params.merge! get_missing_params_from_session(:ratings)
    if new_params.empty? == false then 
      flash.keep
      redirect_to movies_path(new_params)
      return
    end

    session[:sort] = params[:sort] if params[:sort] != nil
    session[:ratings] = params[:ratings] if params[:ratings] != nil

    @title_sort = (session[:sort] == "title")
    @release_sort = (session[:sort] == "release_date")

    @movies = Movie.all(
        :order => session[:sort],
        :conditions => {:rating => if session[:ratings] then session[:ratings].keys else [] end}
        )
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
end
