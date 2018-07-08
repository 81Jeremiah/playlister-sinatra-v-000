require 'sinatra/base'
require 'rack-flash'
class SongsController < ApplicationController
use Rack::Flash

  get '/songs' do
    @songs = Song.all
    erb :'songs/index'
  end

  get '/songs/new' do
    erb :'songs/new'
  end

  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    erb :'songs/show'
  end

  post '/songs' do
    @song = Song.create(name: params[:song_name])
    @song.artist = Artist.find_or_create_by(name: params[:artist_name])
    @song.genre_ids = params[:genres]
    @song.save
    flash[:message] = "Successfully created song."
    redirect to "/songs/#{@song.slug}"
  end

   get '/songs/:slug/edit' do
     @song = Song.find_by_slug(params[:slug])
     erb :'songs/edit'
   end

  patch '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    @artist = Artist.find_or_create_by(name: params[:artist_name]) if !params[:artist_name].empty?
    @genre_ids = params[:genre_ids].collect(&:to_i)
    @song.update(artist: @artist, genre_ids: @genre_ids)
    flash[:message] = "Successfully updated song."
    binding.pry
    redirect to "/songs/#{@song.slug}"
 end

end
