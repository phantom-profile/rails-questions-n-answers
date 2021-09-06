$(document).on('turbolinks:load', function () {
  $('.answers').on('click', '.edit-answer-link', function (event) {
    event.preventDefault()
      $(this).hide()
      let answerId = $(this).data('answerId')
      $('form#form-for-answer-' + answerId).removeClass('hidden')
  })
})