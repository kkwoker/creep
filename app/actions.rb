enable :sessions

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

def sanitize_filename(filename)
  filename.gsub(/[^\w\.\-]/,"_")
end

# Homepage (Root path)
get '/' do
  erb :index
end

get '/test' do
  @photos = Photo.all
  erb :'photo/css_test'
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

  # if the photo is invalid, reload page and post error
  if !(params[:photo] && is_picture?(params[:photo][:filename]))
    # set an error flag to display "Was not an image file" to the form
    @error = true
    erb :'/photo/new'
  end


  # Put the image into /uploads only if it is a picture

  # save the File object into /images
  fname = sanitize_filename(params[:photo][:filename])
  File.open("public/uploads/#{fname}", "w") do |f|
    f.write(params[:photo][:tempfile].read)
  end

  photo = Photo.new(title: params[:title],
                    rating: 0,
                    filename: fname
                    )

  photo.save
  tagnames = params[:tags].split(/W/)

  tagnames.each do |tagname|
    photo.tags << to_tag(tagname)
  end

  redirect '/photos'

end



# Gets the tag information and redirect to filtered photos page
get '/photos/tag' do
  redirect '/photos/tag/' + params[:tags]
end

get '/photos/tag/' do
  redirect '/photos'
end

#Filtered photos page with a single tags
get '/photos/tag/:tag_names' do
  @photos = Photo.all
  @tags =[]
  params[:tag_names].split(/\W/).each do |tag|
    t = to_tag(tag)
    @tags << t
    @photos.keep_if { |photo| photo.tags.include? t}
  end
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
  redirect '/photos/' + params[:photo_id]

end

# add tag on the show page
post '/tag' do
  photo = Photo.find(params[:photo_id])
  tag_arr = params[:tagname].split(/\W/)
  tag_arr.each do |tag_name|
    t = to_tag(tag_name)
    if !photo.tags.include? t
      photo.tags << t
      photo.save
    end
  end
  redirect '/photos/' + params[:photo_id].to_s
end



#About
get '/about' do

  erb :'/photo/about'

end



get '/login' do
  erb :'/user/login'
end

post '/login' do
  if User.exists?(username: params[:username], password: params[:password])
    @user = User.where(username: params[:username], password: params[:password])

    session[:user_id] = @user[0][:id]
    redirect '/photos'
  else
    @error = true
    erb :'user/login'
  end
end

get '/logout' do
  session.clear
  redirect '/photos'
end

get '/profile/:username' do
  erb :'user/profile'
end

get '/signup' do
  erb :'/user/signup'
end

post '/signup' do
  @user = User.new(
    username: params[:username],
    password: params[:password]
  )
  if @user.save
    redirect '/login'
  else
    @error = true
    erb :'/user/signup'
  end
end
