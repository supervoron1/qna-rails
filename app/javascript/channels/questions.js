import consumer from "./consumer";

$(document).on('turbolinks:load', function(){
    $('.question').on('click', '.edit-question-link', function(e) {
        e.preventDefault();
        $(this).hide();
        var questionId = $(this).data('questionId');
        $('form#edit-question-' + questionId).removeClass('hidden');
    });

    consumer.subscriptions.create('QuestionsChannel', {
        connected() {
            // console.log('Connected successfully!!!')
            this.perform('follow');
        },

        received(data) {
            if ($('.no_questions').length) {
                $('.no_questions').remove()

                $('body').append('<table class="questions-list">');
            }

            var questionsList = $('.questions-list');

            questionsList.append(data)
        }
    })
});