/**
 * Created by lukelev07 on 10/4/14.
 */

Parse.initialize("tjUwVLI6219JVwwhcry4HNBWMC60Q3xh8005NHBQ", "GxSaftLTUQ1itlVKSay4QNLkVafIiPrhVgHSqPA7");
// on button-click
function formSubmit(event) {
    if (event && event.preventdefault) {
        event.preventDefault();
    }
    var Entry = Parse.Object.extend("Data");
    var NewEntry = new Entry();

    // Create form object and extract values
    var form = document.getElementById("submit");
    var title = document.getElementById("title").value;
    var description = document.getElementById("description").value;

    // checks if photo attribute exists
    var fileUploadControl = $("#pictures")[0];
    if (fileUploadControl.files.length > 0) {
        var file = fileUploadControl.files[0];
        var name = "photo.jpg";

        var parseFile = new Parse.File(name, file);
    }


    // set fields from html
    NewEntry.set("Title", title);
    NewEntry.set("Description", description);
    NewEntry.set("Picture", parseFile);

    NewEntry.save().then(function(obj){
        console.log("Success");
    });


//        //null, {
//        success: function(NewEntry) {
//            alert('New obj created with obj id: ' + NewEntry.id);
//        },
//        error: function(NewEntry, error) {
//            // Execute any logic that should take place if the save fails.
//            // error is a Parse.Error with an error code and message.
//            alert('Failed to create new object, with error code: ' + error.message);
//        }
//    //});

    return false;
}

// Dynamically allocate templates based upon object presence
function showListings() {

    var source   = $("#listing-template").html();
    var template = Handlebars.compile(source);

    // pull data from parse
    var query = new Parse.Query("Data");
    query.find({
        success: function (results) {
            console.log("Total: "+results.length);

            var finalHTML = template({
                // fetch title and description
                results: results.map(function(o) { return o.toJSON(); })

            })

            $("#listing").append(finalHTML);



        },
        error: function(error) {
            // error happened; you suck!
        }
    });

    // now render the templates in a loop



    return false;
}
