$(document).ready(function() {


/*==================================
Feature : Load all companies with operations
Page : http://localhost/
Element :  Autoload the campanies via ajax .
====================================*/
    function loadCompanies() {

        $(document).on('ready', function() {

        	current_page = $("#current_page").val();

            $.ajax({
                url: '/companies',
                method: 'GET',
                data: {page: current_page},
                success: function(response) {
                  $("#companies_list").html(response);
                },
                error: function(response) {
                    console.log(response);
                }
            });
        })
    }

/*==================================
Feature : Set download CSV URL
Page : http://localhost/
Element :  Set download csv url on change of text field.
====================================*/
    function setDownloadCSVURL(query, company_id){
        if(query == ""){
            query = "*";
        }
        new_url = window.location.origin + "/download_csv/" + company_id + "/" + query ;
        $("#download_csv"+company_id).attr('href', new_url);
    }

/*==================================
Feature : Search through Operations
Page : http://localhost/
Element :  Search box below operations.
====================================*/
    function implementSearchOnOperations(){
        $(document).on('change', '.ops-search', function(){

          query = $(this).val();
          company_id = $(this).attr("data-company-id");
          setDownloadCSVURL(query, company_id);

            $.ajax({
                url: '/companies/' + company_id + '/operations_search',
                data: {query: query},
                method: 'GET',
                success: function(response) {
                  $('#operations_body').html(response);

                },
                error: function(response) {
                    console.log(response);
                }
            });   
        })        
    }


/*==================================
Feature : Load all companies with operations
Page : http://localhost/
Element :  Autoload the campanies via ajax .
====================================*/
    function loadCompanyInfo() {

        $("#companies_list").on('click', ".company_info_show", function() {
        	
        	company_id = $(this).attr("data-company-id");
            loader_url = $("#loader_element").val();
            $('.modal-body').html("<p>Loading Informations....<img src='" + loader_url + "' /></p>");

            $('#myModal').modal('show');

            $.ajax({
                url: '/companies/' + company_id,
                method: 'GET',
                success: function(response) {
                  $('.modal-body').html(response);
                  hideStatus();

                  implementSearchOnOperations();
                },
                error: function(response) {
                    console.log(response);
                }
            });          		
      		

        })
    }


/*==================================
Feature : Load all parsing logs
Page : http://localhost/
Element :  Autoload after upload complete.
====================================*/
    function loadparsingLog() {

            $.ajax({
                url: '/fetch_parsing_logs',
                method: 'GET',
                success: function(response) {
                  $('#parsing_area').html(response);
                  $('#parsing_area').slideDown();
                },
                error: function(response) {
                    console.log(response);
                }
            }); 
    }


/*==================================
Feature : Upload feedback form.
Page : http://localhost
Element : Button upload   click.
====================================*/
    function uploadFeedbackForm(){

        var bar = $('.bar');
        var percent = $('.percent');
        var status = $('#status');
        var progress = $('.progress');
        var uploadText = $('.upload_text');
        var uploadArea = $('#upload_area');
        var parsingArea = $('#parsing_area');
           
        $('#upload_form').ajaxForm({
            beforeSubmit: function(arr, $form, options) { 
                data = arr[0];
                if(data){
                    if (data.value.type != "text/csv"){
                        alert("Invalid file type. Only CSV allowed.")
                        return false 
                    }
                }
                             
            },
            beforeSend: function() {
                uploadArea.slideDown();
                status.empty();
                var percentVal = '0%';
                bar.width(percentVal)
                percent.html(percentVal);
            },
            uploadProgress: function(event, position, total, percentComplete) {
                progress.slideDown();
                var percentVal = percentComplete + '%';
                bar.width(percentVal)
                percent.html(percentVal);
                //console.log(percentVal, position, total);
            },
            success: function() {
                var percentVal = '100%';
                bar.width(percentVal)
                percent.html(percentVal);
            },
            complete: function(xhr) {
                uploadArea.slideUp();
                loadparsingLog();
                uploadText.text(xhr.responseText);
            }
        });        
    }

/*==================================
Feature : Upload feedback click.
Page : http://localhost
Element : Button upload feeback file.
====================================*/
    function uploadFeedback(){

        $(".upload_btn").click(function(){
            $("#upload_widget").slideToggle();
        })

        $(".parse_btn").click(function(){
            $("#parsing_area").slideToggle();
        })
        
        
        uploadFeedbackForm(); 
    }


/*==================================
Feature : Realtime feedback on parsing.
Page : http://localhost
Element : Progres bar with parsing info.
====================================*/
    function realtimeParsingUpdate(){

        // Enable pusher logging - don't include this in production
        Pusher.log = function(message) {
          if (window.console && window.console.log) {
            window.console.log(message);
          }
        };

        var pusher = new Pusher('295955d8e06f90740986');
        var channel = pusher.subscribe('parsing_log');
        channel.bind('parse_operations', function(data) {
          id = data.id
          $("#success_rows" + id).text(data.success_rows);
          $("#failed_rows" + id).text(data.failed_rows);
          $("#total_rows" + id).text(data.total_rows);
          $("#status" + id).text(data.status);
        });       
    }

/*==================================
Feature : Hide and SHow status button.
Page : http://localhost
Element : Inside Modal.
====================================*/
    function hideStatus(){
      $(document).on('click',".hide_stats", function(){
        $("#stats_table").slideToggle();
      })        
    }

/*==================================
Feature : Initializing all Javascript under this controller.
Page : http://localhost
Element : Program start here.
====================================*/

    loadCompanies();
    loadCompanyInfo();
    uploadFeedback();
    realtimeParsingUpdate();

});