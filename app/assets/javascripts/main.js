$(document).ready(function() {
  const LIKE_LABEL = "Like";
  const UNLIKE_LABEL = "UnLike";

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
    var url = `/events/${event_id}/rsvps/${rsvp_id}.js`
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
     // $target.closest('.row').remove();
    })
  }

  function unlikeUser(e) {
    console.log("IN unLikeUser!");
    var $target = $(e.target);
    var event_id = $target.attr('data-event-id');
    var like_id = $target.attr('data-like-id')
    var url = `/events/${event_id}/likes/${like_id}.json`
    console.log(`url= ${url}`);
//    var data = {
//    }
    //console.log("data = ", data)
    $.ajax({
      url: url,
      method: 'delete',
  //    contentType:"application/json; charset=utf-8",
   //   data: data
    }).done(function(){
      console.log("unLiked user")
      console.log(arguments);
      $target.text(LIKE_LABEL);
      $target.attr('data-action', LIKE_LABEL);
      //$target.attr('disabled', true);
      //let quote = arguments[0];
      //appendStudent(student);
    })
  }

  function likeUser(e) {
    console.log("IN likeUser!");
    var $target = $(e.target);
    var event_id = $target.attr('data-event-id');
    var liked_user_id = $target.attr('data-liked-user-id')
    var url = `/events/${event_id}/likes.json`
    console.log(`url= ${url}`);
    var data = {
      liked_user_id: liked_user_id
    }
    console.log("data = ", data)
    $.ajax({
      url: url,
      method: 'post',
  //    contentType:"application/json; charset=utf-8",
      data: data
    }).done(function(data){
      console.log("Liked user. Data = ", data)
      //console.log(arguments);
      $target.text(UNLIKE_LABEL);
      $target.attr('data-action', UNLIKE_LABEL);
      $target.attr('data-like-id', data.id);
      //$target.attr('disabled', true);
      //let quote = arguments[0];
      //appendStudent(student);
    })
  }

  function toggleLikeUser(e) {
    var $target = $(e.target);
    console.log('target = ', $target);
    var action = $target.attr('data-action');
    console.log(`action = ${action}`);
    if (action === LIKE_LABEL) {
      likeUser(e);
    } else if (action === UNLIKE_LABEL) {
      unlikeUser(e);
    } else {
      console.log("Unknown Action")
    }
  }

//  $(".event-rsvp").click(saveRsvp);
  $("#event_rsvp_list").on('click', '.event-rsvp', saveRsvp);
//  $(".event-unrsvp").click(deleteRsvp);
  $('#event_rsvp_list').on('click', '.event-unrsvp', deleteRsvp);
//  $('#event_rsvp_list').on('click', '.event-like-user', likeUser);
//  $('#event_rsvp_list').on('click', '.event-unlike-user', likeUser);
  $('#event_rsvp_list').on('click', '.event-toggle-like-user', toggleLikeUser);

  $(".dropdown-button").dropdown();
  $('select').material_select();
})