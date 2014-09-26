$(document).ready(function() {

  // See: http://docs.jquery.com/Tutorials:Introducing_$(document).ready()


   function readURL(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            
            reader.onload = function (e) {
                $('#blah').attr('src', e.target.result);
            }
            
            reader.readAsDataURL(input.files[0]);
        }
    }
    
    $("#imgInp").change(function(){
        readURL(this);
    });


    function checkSize(max_img_size)
    {
        var input = document.getElementById("upload");
        // check for browser support (may need to be modified)
        if(input.files && input.files.length == 1)
        {           
            if (input.files[0].size > max_img_size) 
            {
                alert("The file must be less than " + (max_img_size/1024/1024) + "MB");
                return false;
            }
        }

        return true;
    }
   
});
