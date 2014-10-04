/**
 * Created by lukelev07 on 10/4/14.
 */

Parse.initialize("tjUwVLI6219JVwwhcry4HNBWMC60Q3xh8005NHBQ", "GxSaftLTUQ1itlVKSay4QNLkVafIiPrhVgHSqPA7");

// on button-click
function formSubmit() {
    var Entry = Parse.Object.extend("Data");
    var NewEntry = new Entry();

    // Create form object and extract values
    var form = document.getElementById("submit");
    var title = document.getElementById("title").value;
    //var email = form.getElementsById("email");
    var description = document.getElementById("description").value;
    var picture = document.getElementById("pictures");

    //var tiitle = $(".title_field").val();

    // set fields from html
    NewEntry.set("Title", title);
    NewEntry.set("Description", description);
//    NewEntry.set("Picture", picture);

    NewEntry.save();


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
