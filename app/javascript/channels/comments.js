import consumer from "./consumer";

$(document).on('turbolinks:load', function () {
    $('.question').on('click', '.new-comment', function (e) {
        e.preventDefault();
        $(this).hide();
        var commentableId = $(this).data('commentableId');
        $('form#new-comment-' + commentableId).removeClass('hidden');
    });

    $('.answer').on('click', '.new-comment', function (e) {
        e.preventDefault();
        $(this).hide();
        var commentableId = $(this).data('commentableId');
        $('form#new-comment-' + commentableId).removeClass('hidden');
    });

    $('form[id*="new-comment"]').on('ajax:success', function(e) {
        var comment = e.detail[0][0].comment;

        $('.' + comment.commentable_type.toLowerCase() + ' .comments-' + comment.commentable_id + ' ul').append('<li>' + comment.body + '</li>');

        this.querySelector('#comment_body').value = ''
        $('.' + comment.commentable_type.toLowerCase() + ' .comments-' + comment.commentable_id + ' .comments-errors').empty();
    })
        .on('ajax:error', function(e) {
            var comment = e.detail[0][0].comment;

            $('.' + comment.commentable_type.toLowerCase() + ' .comments-' + comment.commentable_id + ' .comments-errors').empty();

            var errors = e.detail[0][0].errors;

            $.each(errors, function(index, value) {
                $('.' + comment.commentable_type.toLowerCase() + ' .comments-' + comment.commentable_id + ' .comments-errors')
                    .append('<p>' + value + '</p>');
            });
        });

    consumer.subscriptions.create('CommentsChannel', {
        connected() {
            this.perform('follow');
        },

        received(data) {
            if(gon.user_id !== data.user_id) {
                $('.' + data.commentable_type.toLowerCase() + ' .comments-' + data.commentable_id + ' ul').append('<li>' + data.comment + '</li>');
            }
        }
    })
});