# Homepage (Root path)
get '/' do
  erb :index
end




# Display all pictures
get '/pictures'

end


# Show form to create new picture
get '/pictures/new'

end


# Create a new picture
post '/pictures'

end


# Show picture with id = #
get '/pictures/:id'

end


#Filtered pictures page with a single tags
get '/pictures/tag/:id' do

end


#About
get '/about' do

end


#Secret admin login
get '/login' do

end