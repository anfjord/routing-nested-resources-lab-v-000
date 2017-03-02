class SongsController < ApplicationController
  def index
    if params[:artist_id] && Artist.find_by(id: params[:artist_id])
      @songs = Artist.find(params[:artist_id]).songs
    elsif params[:artist_id] && !Artist.find_by(id: params[:artist_id])
      @songs = Song.all
      redirect_to artists_path, notice: "Artist not found"
    else
      @songs = Song.all
    end
  end

  def show
    @artist = Artist.find_by(id: params[:artist_id])
    @song = Song.find_by(id: params[:id])
    if params[:artist_id] && @artist.songs.include?(@song)
    elsif params[:artist_id]  && !@artist.songs.include?(@song)
      redirect_to artist_songs_path(@artist.id), alert: "Song not found"
    else
      @song = Song.find(params[:id])
    end
  end

  def new
    @song = Song.new
  end

  def create
    @song = Song.new(song_params)

    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  def edit
    @song = Song.find(params[:id])
  end

  def update
    @song = Song.find(params[:id])

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist_name)
  end
end
