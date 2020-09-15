class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # for checkbox form on ratings
    @all_ratings = Movie.all_ratings
    
    @movies = Movie.all

    # save our settings in the session store
    session[:settings] = {} unless session[:settings]
    if params[:key]
      params[:ratings] ||= session[:settings]['ratings']
      session[:settings] = {
        :key => params[:key],
        :asc => params[:asc],
      }
    end
    if params[:ratings]
      session[:settings]['ratings'] = params[:ratings]
    end

    # switches for individual ordering based on our parameters
    if params[:key] == 'title'
      # @title_glyph = glyph_html
      @title_css = 'hilite'
      @movies = Movie.order(:title)
    elsif params[:key] == 'release_date'
      # @release_glyph = glyph_html
      @release_css = 'hilite'
      @movies = Movie.order(:release_date)
    # if there were saved settings, redirect to that
    else
      # restructure this catch case of no params elements?
      if session[:settings]
        flash.keep
        if session[:settings]['key']
          redirect_to movies_path(key: session[:settings]['key'], asc: session[:settings]['asc'], ratings: session[:settings]['ratings'])
          return
        elsif params[:ratings].nil? && session[:settings]['ratings']
          redirect_to movies_path(ratings: session[:settings]['ratings'])
          return
        end
      end
      # no session store catch-all case
      @movies = Movie.all
    end
    if session[:settings] && (not params[:ratings])
      session[:settings]['ratings'] ||= Hash[ @all_ratings.map { |x| [x,1] } ]
      cached_params = { key: session[:settings]['key'], asc: session[:settings]['asc'], ratings: session[:settings]['ratings'] }
      redirect_to movies_path(cached_params)
      return
    end
    puts params[:something]
    
    if params[:ratings] != nil
      @movies = @movies.where(rating: params[:ratings].keys)
    end
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
