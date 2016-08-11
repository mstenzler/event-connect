$(document).ready(function() {
  function saveRsvp(e) {
    var $target = $(e.target);
    var event_id = $target.attr('data-event-id');
    var url = `/events/${event_id}/rsvps.js`
    console.log(`url= ${url}`);
    var data = {
    }

    $.ajax({
      url: url,
      method: 'post',
  //    contentType:"application/json; charset=utf-8",
      data: data
    }).done(function(){
      console.log("Saved RSVP")
      console.log(arguments);
      $target.text("Saved");
      $target.attr('disabled', true);
      //let quote = arguments[0];
      //appendStudent(student);
    })
  }

  function deleteRsvp(e) {
    console.log("IN deleteRsvp");
    var $target = $(e.target);
    var event_id = $target.attr('data-event-id');
    var rsvp_id = $target.attr('data-rsvp-id');
    var url = `/events/${event_id}/rsvps/${rsvp_id}.json`
    var data = {
    }

    console.log(`url= ${url}`);
    $.ajax({
      url: url,
      method: 'delete',
      contentType:"application/json; charset=utf-8",
      data: data
    }).done(function(){
      console.log(arguments);
      $target.closest('.row').remove();
    })
  }


  $(".event-rsvp").click(saveRsvp);
//  $(".event-unrsvp").click(deleteRsvp);
  $('#event_rsvp_list').on('click', '.event-unrsvp', deleteRsvp);

  $(".dropdown-button").dropdown();
})