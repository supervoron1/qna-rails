$(document).on('turbolinks:load', function() {
    $('.like-button').on('ajax:success', function(e) {
        var votableId = e.detail[0][0].id
        var rating = e.detail[0][0].rating

        $('.votes-' + votableId + ' .votes').html('Votes: ' + rating);

        $('.votes-' + votableId + ' .cancel-button').removeClass('hidden');
        $('.votes-' + votableId + ' .like-button').addClass('hidden');
        $('.votes-' + votableId + ' .dislike-button').addClass('hidden');
    });

    $('.dislike-button').on('ajax:success', function(e) {
        var votableId = e.detail[0][0].id
        var rating = e.detail[0][0].rating

        $('.votes-' + votableId + ' .votes').html('Votes: ' + rating);

        $('.votes-' + votableId + ' .cancel-button').removeClass('hidden');
        $('.votes-' + votableId + ' .like-button').addClass('hidden');
        $('.votes-' + votableId + ' .dislike-button').addClass('hidden');
    });

    $('.cancel-button').on('ajax:success', function(e) {
        var votableId = e.detail[0][0].id
        var rating = e.detail[0][0].rating

        $('.votes-' + votableId + ' .votes').html('Votes: ' + rating);

        $('.votes-' + votableId + ' .cancel-button').addClass('hidden');
        $('.votes-' + votableId + ' .like-button').removeClass('hidden');
        $('.votes-' + votableId + ' .dislike-button').removeClass('hidden');
    });
});