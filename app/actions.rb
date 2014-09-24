# Homepage (Root path)
get '/' do
  erb :index
end

	
# Display all photos
get '/photos' do

end
	
	
# Show form to create new photos
get '/photos/new' do
	erb :'/photo/new'
end


# Create a new photos
post '/photos' do

	# save the File object into /images
	File.open('public/uploads/' + params[:photo][:filename], "w") do |f|
    f.write(params[:photo][:tempfile].read)
  end


end
	

# Show photo with id = #
get '/photos/:id' do
# @photos = Photo.new.find params[:id]
erb :'photo/show'
end


#Filtered photos page with a single tags
get '/photos/tag/:id' do

end


#About
get '/about' do

end


#Secret admin login
get '/login' do

end