def is_picture?(filename)
	filename =~ /([^\s]+(\.(?i)(JPG|jpg|PNG|png|GIF|gif|BMP|bmp))$)/
end

# Homepage (Root path)
get '/' do
  erb :index
end

	
# Display all photos
get '/photos' do
  erb :'/photo/photo'
end
	
	
# Show form to create new photos
get '/photos/new' do
	erb :'/photo/new'
end


# Create a new photos
post '/photos' do

	# Put the image into /uploads only if it is a picture
	if params[:photo] && is_picture?(params[:photo][:filename])
		# save the File object into /images
		File.open('public/uploads/' + params[:photo][:filename], "w") do |f|
	    f.write(params[:photo][:tempfile].read)
	  end

	  redirect '/photos'
	else
		# set an error flag to display "Was not an image file" to the form
		@error = true
		erb :'/photo/new'
	end

end
	

# Show photo with id = #
get '/photos/:id' do
  erb :'/photo/show'
end


#Filtered photos page with a single tags
get '/photos/tag/:id' do
  erb :'/photo/tag'
end


#About
get '/about' do

end


#Secret admin login
get '/login' do

end