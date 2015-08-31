AvidTest.User = {

    /**
     * Function to add users
     * send an ajax request to our rails app with user params
     */
     validate: function(){
        email = $('#add_user_form #email').val();
        name = $('#add_user_form #name').val();
        birth_date = $('#add_user_form #birth_date').val();
        password = $('#add_user_form #password').val();
        password_confirmation = $('#add_user_form #password_confirmation').val();

        if(email == "" || name == "" || birth_date == "" || password == "" || password_confirmation == "") {
            $.notify("All fields are mandatory", "error");
            return false
        }

        if(password.length < 8){
            $.notify("Password length should not be less than 8", "error");
            return false
        }

        if(password_confirmation != password){
            $.notify("Password and Confirmation does not match", "error");
            return false
        }


        today = new Date();
        birth_date_j = new Date(birth_date);
        if(today < birth_date_j){
            $.notify("Date of birth is in future", "error");
            return false            
        }

          var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
          if (regex.test(email) == false){
            $.notify("Invalid Email", "error");
            return false               
          }

        return true
     },

    /**
     * Function to add users
     * send an ajax request to our rails app with user params
     */
    addUser: function() { 
        $('#add_user_form').on('submit', function() {

            if (AvidTest.User.validate()){
                form_params = {user: $(this).serializeObject()};
                $('#add_user_form #submit_user').val("Adding ...");

                AvidTest.Common.callAPI("api/users.json", form_params ,  function(response){

                    $.notify("Successfully created user", "success");
                    $('#add_user_form #submit_user').val("Add");
                    $("#user_close").click();
                    new_user_html = AvidTest.User.parseUserInfo(response);
                    $("#user_list").append(new_user_html);
                })                
            }

            return false
        })
    },  

    /**
     * Function to parse UserInfo
     * Populate new user table row.
     */
    parseUserInfo: function(response) {
        console.log(response);
        email = "<tr><td><a href=/messages/list?user_id=" + response.user.id +">" + response.user.id +"." + response.user.email + "</a></td>";
        name = "<td><a href=/messages/list?user_id=" + response.user.id +">" + response.user.name + "</a></td>";
        gender = "<td>" + response.user.gender + "</td>";
        country = "<td>" + response.user.country + "</td>";
        age = "<td>" + response.user.birth_date + "</td></tr>";

        return email+name+gender+country+age
    },


    /**
     * Function to initualize users javascript methods
     * This is the starting point for all user methods.
     */
     initialize: function(){
        AvidTest.User.addUser();
     } 

};
