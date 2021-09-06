$(document).on('turbolinks:load', function () {
    $('.questions').on('click', '.edit-question-link', function (event) {
        event.preventDefault()
        $(this).hide()
        let questionId = $(this).data('questionId')
        $('form#form-for-question-' + questionId).removeClass('hidden')
    })
})