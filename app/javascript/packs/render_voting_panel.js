$(document).on('turbolinks:load', function () {
  $('.voting-panel').on('ajax:success', function(e) {
    let voting = e.detail[0]
    let votingPanel = $(`.voting-panel.${voting.resource_id}`)
    votingPanel.find('.vote-statistic').html(`<p>Question rating</p><p>${voting.rating}</p>`)
    votingPanel.find('.voting').html("You successfully voted")
    votingPanel.find('.unvoting').html("You unvoted")
    })
})