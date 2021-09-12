$(document).on('turbolinks:load', function () {
    $('form.new-answer').on('ajax:success', function(e) {
        console.log(e.detail)
        let answer = e.detail[0]

        $('.answers').append(`<p> ${answer.body} </p>`)
    })
        .on('ajax:error', function (e) {
            let errors = e.detail[0]
            $.each(errors, function (index, value) {
                $('.answer-errors').html('').append(`<p> ${value} </p>`)
            })
        })
})