$(document).on('turbolinks:load', function () {
    $('.answers').on('click', '.edit-answer-link', function (e) {
        e.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('hidden');
    });

    $('form.new-answer').on('ajax:success', function (e) {
        var answer = e.detail[0][0].answer;

        if ($('.no_answers').length) {
            $('.no_answers').remove()
            $('.answers').append('<div class="answers-list">');
        }
        $('.answers-list').append('<div class="answer" data-answer_id=' + answer.id + '>');
        $('.answer[data-answer_id=' + answer.id + ']').append('<p>' + answer.body + '</p>');

        document.querySelector('.new-answer #answer_body').value = ''
        document.querySelector('.answer-errors').innerHTML = ''

        $('.new-answer').find('input').each(function() {
            $(this).val('');
        });

        const files = e.detail[0][0].files

        if (files.length) {
            $('.answer[data-answer_id=' + answer.id + ']').append('<div class="files-' + answer.id + '"><p>Files:</p><ul>');
            files.forEach(file =>
                $('.answer[data-answer_id=' + answer.id + '] div[class^="files"] ul').append('<li><a href="#">' + file + "</a></li>"))
            $('<div class="files-' + answer.id + '"><ul>').append('</ul>');
        }

        const links = e.detail[0][0].links

        if (links.length) {
            $('.answer[data-answer_id=' + answer.id + ']').append('<div class="links-' + answer.id + '"><p>Links:</p><ul>');

            for (let link of links) {
                if (link.url.startsWith('https://gist.github.com/')) {
                    $('.answer[data-answer_id=' + answer.id + '] div[class^="links"] ul').append('<li><div data-gist="' + link.url + '"><a href="' + link.url + '">' + link.name + "</a></div>");
                } else {
                    $('.answer[data-answer_id=' + answer.id + '] div[class^="links"] ul').append('<li><a href="' + link.url + '">' + link.name + "</a></li>");
                }
            }

            $('<div class="links-' + answer.id + '"><ul>').append('</ul>');
        }
    })
        .on('ajax:error', function (e) {
            $('.answer-errors').empty();

            var errors = e.detail[0];
            $.each(errors, function (index, value) {
                $('.answer-errors').append('<p>' + value + '</p>')
            });
        })
});