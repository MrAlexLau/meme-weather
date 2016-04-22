(function (ns) {
  ns.ManageMemes = {
    Filters: {
      bindEvents: function () {
        $('.filter-btn').on('click', function (e) {
          var $target = $(e.currentTarget),
              newValue = !$target.data('active');

          $target.data('active', newValue);
          $target.toggleClass('active');
          $target.toggleClass('btn-primary');

          ns.ManageMemes.render();
        });
      }
    },

    render: function () {
      var url = '/memes/search',
          filters = {};

      $('.filter-btn').each(function (index, el) {
        var $el = $(el),
            value = 0;

        if ($el.data('active')) {
          value = 1;
        }

        filters[$el.data('filter-name')] = value;
      });

      $.ajax({
        url: url,
        data: filters
      })
      .done(_.bind(function(result) {
        this.bindEvents();
      }, this))
      .fail(_.bind(function() {
        alert("Could not load images.");
      }, this));
    },

    selector: function (name, imageId) {
      var map = {
        'rating': '.meme-image-' + imageId + ' .meme-rating'
      };

      return $(map[name]);
    },

    voteDown: function (e) {
      var imageId = $(e.currentTarget).data('image-id'),
          url = "/memes/" + imageId + "/vote_down",
          previousValue = parseInt(this.selector('rating', imageId).val());

      this.submitVote(url);
      this.selector('rating', imageId).val(previousValue - 1);
    },

    voteUp: function (e) {
      var imageId = $(e.currentTarget).data('image-id'),
          url = "/memes/" + imageId + "/vote_up",
          previousValue = parseInt(this.selector('rating', imageId).val());

      this.submitVote(url);
      this.selector('rating', imageId).val(previousValue + 1);
    },

    submitVote: function (url) {
      $.ajax({
        url: url,
        method: 'PUT'
      })
      .fail(_.bind(function() {
        console.log('Vote failed')
      }, this))
    },

    bindEvents: function () {
      $('.manage-memes .vote-down').on("click", _.bind(ns.ManageMemes.voteDown, ns.ManageMemes));
      $('.manage-memes .vote-up').on("click", _.bind(ns.ManageMemes.voteUp, ns.ManageMemes));
    }
  };

  $(function() {
    ns.ManageMemes.render();
    ns.ManageMemes.Filters.bindEvents();
  });
})(window.MemeWeather);
