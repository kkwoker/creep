enable :sessions

def yo_subscribers(tag)

  # get list of subscribers from tag_subscriptions
  tag_subs = TagSubscription.where(tag_id: tag.id)
  yo_subbers = tag_subs.map { |ts| User.find(ts.user_id).yo_username}
  
  # yo them all
  yo_subbers.each do |y|
    system "curl --data \"api_token=53463db4-646c-1220-da20-8b2d73de9fec&username=#{y}&link=http://optional-link.com\" http://api.justyo.co/yo/"
  end
  
end

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
                    filename: fname,
                    user_id: session[:user_id]
                    )

  photo.save
  tagnames = params[:tags].split(/\W/).keep_if{|t| !t.empty?}
  tagnames << params[:title]
  tagnames.each do |tagname|
    t = to_tag(tagname) 
    photo.tags << t 

    # YO all users subscribed to this tag
    yo_subscribers(t)
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
  params[:tag_names].split(/\W/).keep_if{|t| !t.empty?}.each do |tag|
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
  tag_arr = params[:tagname].split(/\W/).keep_if{|t| !t.empty?}
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
  session[:user_id] = nil
  redirect '/photos'
end

get '/profile/:username' do
  @user = User.find_by(username: params[:username])
  @user_photos = Photo.where(user_id: @user.id)
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

# YO STUFF
post '/subscribe' do
  logged_user = User.find(session[:user_id])
  TagSubscription.new(user_id: logged_user.id, tag_id: params[:tagid]).save
  redirect '/photos'
end

post '/addYOusername' do
  user = User.find(session[:user_id])
  user.yo_username = params[:YOname]
  user.save

  redirect '/profile/' + user.username

end
