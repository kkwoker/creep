def is_picture?(filename)
	filename =~ /([^\s]+(\.(?i)(JPG|jpg|PNG|png|GIF|gif|BMP|bmp))$)/
end

# Returns tag if it is already in the database. If not, add the tag to the database and return the tag
def to_tag(name)
	tag = Tag.find_by(name: name)
	if tag.nil?
		tag = Tag.new(name: name)
		tag.save
	end
	tag
end

# Homepage (Root path)
get '/' do
  erb :index
end

	
# Display all photos
get '/photos' do
	@photos = Photo.all
  erb :'/photo/main'

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
	  tag = to_tag(params[:tags])

  	photo = Photo.new(title: params[:title],
  					  			 rating: 0,
  								 filename: params[:photo][:filename],
  								 tag_id: tag.id
  										)
  	photo.save
	  redirect '/photos'
	else
		# set an error flag to display "Was not an image file" to the form
		@error = true
		erb :'/photo/new'
	end

end
	


# Gets the tag information and redirect to filtered photos page
get '/photos/tag' do

	redirect '/photos/tag/' + params[:tag]
end

#Filtered photos page with a single tags
get '/photos/tag/:tag_name' do #instead of id, use tag name
	
	@tag = to_tag(params[:tag_name])
	@photos = Photo.where(tag_id: @tag.id)
  erb :'/photo/main'

end

# Show photo with id = #
get '/photos/:id' do

	@photo = Photo.find(params[:id])
  erb :'/photo/show'
  
end
# apply comments to the database

post '/comment' do
  @comment = Comment.new(
    body: params[:body],
    photo_id: params[:photo_id]
    )
  @comment.save
  redirect '/photos/'+params[:photo_id]
end


#About
get '/about' do
  erb :'/photo/tag'
end


#Secret admin login
get '/login' do

end