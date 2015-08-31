$(document).ready(function() {


    /*==================================
    Feature : Filter Products 
    Page : http://firstnational.plainandsimpleapp.com/categories/:id/products
    Element : Generic Functions
    ====================================*/

    //Default Query Builder using local storage
    function initQueryBuilder() {

        $("input[type='radio'], input[type='checkbox']").ionCheckRadio();
        obj = {
            sort_mode: "Default Sorting",
            price_mode: "",
            color_mode: [],
            discount_mode: "",
            page: 1,
            category_id: $("#category_id").val()
        }

        localStorage["query_builder"] = JSON.stringify(obj);
        return obj
    }

    //Load Query Builder
    function loadQueryBuilder() {
        if (typeof localStorage["query_builder"] != "undefined") {

            return JSON.parse(localStorage["query_builder"]);
        } else {
            return initQueryBuilder()
        }

    };

    //Save Query Builder
    function saveQueryBuilder(obj) {
        localStorage["query_builder"] = JSON.stringify(obj);
    };



    // Reload products via AJAX request using query builder as parameter.
    function reloadProducts(query) {

        url = window.location.origin + window.location.pathname;
        $.ajax({
            url: url,
            method: 'GET',
            data: query,
            success: function(response) {
                $("#product_lists_paginated").html(response);
            },
            error: function(response) {
                console.log(response);
            }
        });
    }

    //Function to init sort drop down
    function initSortDropDown() {
        query = loadQueryBuilder();
        sort_mode = query.sort_mode
        if (sort_mode != "Default Sorting") {
            $(".minict_wrapper .selected minict_first").removeClass('selected minict_first');
            $(".minict_wrapper li[data-value='" + sort_mode + "']").addClass('selected minict_first');
        }
    }

    /*==================================
Feature : Filter Products 
Page : http://firstnational.plainandsimpleapp.com/categories/:id/products
Element : Default sorting
====================================*/

    function sortProduct() {

        $("#product_lists_paginated").on('change', "#sort_category_products", function() {
            query = loadQueryBuilder();
            query.sort_mode = $(this).val();

            saveQueryBuilder(query)
            reloadProducts(query)
        });
    }

    /*==================================
Feature : Filter Products 
Page : http://firstnational.plainandsimpleapp.com/categories/:id/products
Element : Price Filter on sidebar using Form for price from and to.
====================================*/

    function priceFilterForm() {

        $("#price_filter_form").on('submit', function() {

            price_from = $("#price_filter_form #price_from").val();
            price_to = $("#price_filter_form #price_to").val();

            if ((price_from == "") && (price_to == "")) {

                $.notify("Please enter from or to prices");
                return false

            } else {

                query = loadQueryBuilder();
                price = price_from + "-" + price_to;
                query.price_mode = price;

                saveQueryBuilder(query)
                reloadProducts(query)
                return false
            }

        });
    }

    /*==================================
Feature : Filter Products 
Page : http://firstnational.plainandsimpleapp.com/categories/:id/products
Element : Price Filter on sidebar using Radio button.
====================================*/
    function priceFilterRadio() {

        $.each($("#collapsePrice [id^='icr-']"), function(idx, ele) {
            $(ele).on('click', function() {

                //If ION Check Object is Radio Button for Price Filter.
                if ($(ele).children('.icr__text').children().length == 0) {

                    $("#price_filter_form")[0].reset();
                    query = loadQueryBuilder();
                    price_mode = $(ele).children('.icr__text').text();

                    if (($(ele).hasClass('checked')) && (price_mode != "Don't know")) {

                        query.price_mode = price_mode;

                    } else {

                        query.price_mode = "";
                    }

                    saveQueryBuilder(query);
                    reloadProducts(query);

                }

            })
        });

    }

    /*==================================
    Feature : Filter Products 
    Page : http://firstnational.plainandsimpleapp.com/categories/:id/products
    Element : Color Filter on left sidebar.
    ====================================*/
    function clearPriceFilter(){
        $(".clearPriceFilter").on('click', function(){
            $("#price_filter_form")[0].reset();
            $("#icr-7").trigger("click"); // Click the Don't know option
        });
    }



    /*==================================
    Feature : Filter Products 
    Page : http://firstnational.plainandsimpleapp.com/categories/:id/products
    Element : Color Filter on left sidebar.
    ====================================*/
    function colorFilterProducts() {

        $.each($("#collapseColor span[id^='icr-']"), function(idx, ele) {
            $(ele).on('click', function() {

                //If ION Check Object is CheckBox for Color Filter.
                if ($(ele).children('.icr__text').children().length > 0) {

                    query = loadQueryBuilder();
                    color_mode = $(ele).children('.icr__text').children("small").attr("data-color-code");


                    if ($(ele).hasClass('checked')) {

                        query.color_mode.push(color_mode);

                    } else {

                        query.color_mode.pop(color_mode);
                    }

                    saveQueryBuilder(query);
                    reloadProducts(query);
                }


            })
        });
    }

    /*==================================
Feature : Filter Products 
Page : http://firstnational.plainandsimpleapp.com/categories/:id/products
Element : Discount percentage on left sidebar.
====================================*/
    function discountFilterProducts() {

        $.each($("#collapseThree span[id^='icr-']"), function(idx, ele) {
            $(ele).on('click', function() {

                //If ION Check Object is CheckBox for Color Filter.

                query = loadQueryBuilder();
                discount = $(ele).children('.icr__text').text();

                if ($(ele).hasClass('checked')) {

                    query.discount_mode = discount;

                } else {

                    query.discount_mode = "";
                }

                saveQueryBuilder(query);
                reloadProducts(query);



            })
        });
    }

    /*==================================
Feature : Clear All Product Filters
Page : http://firstnational.plainandsimpleapp.com/categories/:id/products
Element : Clear Filters.
====================================*/
    function clearFilters() {
        $("#clear_product_filters").on('click', function() {
            query = initQueryBuilder();
            reloadProducts(query);
            return false
        })
    }


    /*==================================
Feature : Clear All Product Filters
Page : http://firstnational.plainandsimpleapp.com/categories/:id/products
Element :  Add to cart .
====================================*/
    function addProductToCart() {

        $(document).on('click', ".add_products_to_cart", function() {

            product_id = $(this).attr("data-product-id");
            $(this).removeClass().addClass("btn btn-danger added-product");
            $(this).html("<span class='add2cart'><i class='glyphicon glyphicon-shopping-cart'> </i>Adding... </span>");

            $.ajax({
                url: '/shopping_carts/add_to_cart',
                method: 'POST',
                data: {
                    product_id: product_id
                },
                success: function(response) {
                    $("#shopping_cart").html(response.html);

                    $(".added-product[data-product-id='" + response.product_id + "']").removeClass().addClass("btn btn-default added-product");
                    $(".added-product[data-product-id='" + response.product_id + "']").html("<span class='add2cart'><i class='glyphicon glyphicon-shopping-cart'> </i>Added to cart </span>");
                    show_cart_dropdown();
                    $.notify("Product added to cart.", "success");
                },
                error: function(response) {
                    console.log(response);
                }
            });
        })
    }

    function show_cart_dropdown() {
        $(".shopping-cart.dropdown-menu").css("display", "");
    }

    function hide_cart_dropdown() {
        if ($(".shopping-cart.dropdown-menu").find("tr").length == 0) {
            $(".shopping-cart.dropdown-menu").hide();
        }
    }
    hide_cart_dropdown();

    /*==================================
Feature : Add to cart variant
Page : http://firstnational.plainandsimpleapp.com/categories/:id/products
Element :  Add to Cart from store page.
====================================*/
    function addVariantToCart() {

        $(document).on('click', ".add_products_to_cart_variant", function() {

            product_id = $(this).attr("data-product-id");
            quantity = $("#product_quantity" + product_id).val();
            ele = this;
            $(ele).text("Adding .....");

            $.ajax({
                url: '/shopping_carts/add_to_cart_variant',
                method: 'POST',
                data: {
                    product_id: product_id,
                    quantity: quantity
                },
                success: function(response) {
                    $("#shopping_cart").html(response);
                    $(ele).removeClass().addClass("link-wishlist wishlist");
                    $(ele).text("Added to Cart");
                    $.notify("Product added to cart.", "success");
                },
                error: function(response) {
                    console.log(response);
                }
            });
        })

    }

    /*==================================
Feature : Clear All Product Filters
Page : http://firstnational.plainandsimpleapp.com/categories/:id/products
Element :  Add to cart .
====================================*/
    function removeProductFromCart() {

        $(document).on('click', ".cart_product_delete", function() {

            data = {
                shopping_cart_id: $(this).attr("data-cart-product-id")
            }
            $.ajax({
                url: '/shopping_carts/remove_from_cart',
                method: 'POST',
                data: data,
                success: function(response) {
                    $("#shopping_cart").html(response);
                    hide_cart_dropdown();
                    $.notify("Product removed from cart.", "success");
                },
                error: function(response) {
                    console.log(response);
                }
            });
        })
    }


    /*==================================
Feature : To  switch products with idemtical codes
Page : http://firstnational.plainandsimpleapp.com/products/2947
Element :  Select Size.
====================================*/
    function swithProductVariant() {

        $("#variant_view").on('change', ".variant_change_color", function() {

            product_id = $("#data-product-id").val();
            color_code = $(this).val();

            data = {
                color_code: color_code,
                product_id: product_id
            }

            $.ajax({
                url: '/products/switch_variant_by_color',
                method: 'POST',
                data: data,
                success: function(response) {

                    $("#variant_view").html(response)

                },
                error: function(response) {
                    console.log(response);
                }
            });

        });

        $("#variant_view").on('change', ".variant_change_size", function() {

            product_id = $("#data-product-id").val();
            color = $("#product_color_codes" + product_id).val();
            size = $("#product_sizes" + product_id).val();

            data = {
                size: size,
                color: color,
                product_id: product_id
            }

            $.ajax({
                url: '/products/switch_variant_by_size',
                method: 'POST',
                data: data,
                success: function(response) {

                    $("#variant_view").html(response)

                },
                error: function(response) {
                    console.log(response);
                }
            });

        });


    }

    /*==================================
Feature : To  switch products with idemtical codes
Page : http://firstnational.plainandsimpleapp.com/products/2947
Element :  Select Size.
====================================*/
    function quickViewFeature(){

        $(document).on('click', ".btn-quickview", function(){

            id = $(this).attr("data-product-id");
            $.ajax({url: '/products/quick_view' ,
                          method: 'POST',
                          data: {id: id},
                          success: function(response){
                           
                           $("#quick_view").html(response).modal('show');
                           
                          },
                          error: function(response){
                             console.log(response);
                          }
            });         
        })

        $(document).on('click', ".btn-quickview1", function(){

            id = $(this).attr("data-product-id");
            $.ajax({url: '/products/quick_view' ,
                          method: 'POST',
                          data: {id: id},
                          success: function(response){
                           
                           $("#quick_view").html(response).modal('show');
                           
                          },
                          error: function(response){
                             console.log(response);
                          }
            });         
        })

        $("#quick_view").on('change', ".quick_view_change_color", function(){

              product_id = $("#quick-view-data-product-id").val();
              color_code = $(this).val();

              data = {color_code: color_code, product_id: product_id}

              $.ajax({url: '/products/switch_quickview_by_color' ,
                          method: 'POST',
                          data: data,
                          success: function(response){
                           
                           $("#quick_view").html(response);
                           
                          },
                          error: function(response){
                             console.log(response);
                          }
              });

        });

        $("#quick_view").on('change', ".quick_view_change_size", function(){

              product_id = $("#quick-view-data-product-id").val();
              color = $("#product_color_codes"+ product_id).val();
              size = $("#product_sizes"+ product_id).val();

              data = {size: size, color: color, product_id: product_id}

              $.ajax({url: '/products/switch_quickview_by_size' ,
                          method: 'POST',
                          data: data,
                          success: function(response){
                           
                            $("#quick_view").html(response);
                           
                          },
                          error: function(response){
                             console.log(response);
                          }
              });

        });


    }

/*==================================
Feature : Filter Products 
Page : http://firstnational.plainandsimpleapp.com/categories/:id/products
Element : Program start here.
====================================*/

    initQueryBuilder();

    priceFilterRadio();

    sortProduct();

    priceFilterForm();

    colorFilterProducts();

    discountFilterProducts();

    clearFilters();

    addProductToCart();

    removeProductFromCart();

    swithProductVariant();

    addVariantToCart();

    quickViewFeature();

    clearPriceFilter()
});