// $(document).ready(function(){
//   $(".delete-bulk").on("click", function(){
//     confirm_msg = "Are you sure?";
//     var post_ids=[];
//     $('input[type=checkbox]:checked').each(function(){
//       post_ids.push($(this).val());
//     });
//     if((post_ids.length > 0) && confirm(confirm_msg))
//       $.ajax({
//         type: "delete",
//         dataType: "json",
//         url: "/posts_manager/destroy_posts",
//         data: {post_ids: post_ids},
//         success: function () {
//           $('input[type=checkbox]:checked').each(function(){
//             $(this).closest('tr').fadeOut();
//           });
//         }
//       });
//   });
// });
