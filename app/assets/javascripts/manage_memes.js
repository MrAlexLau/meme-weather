(function (ns) {
  ns.ManageMemes = {
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
    }
  };

  $(function() {
    $('.manage-memes .vote-down').on("click", _.bind(ns.ManageMemes.voteDown, ns.ManageMemes));
    $('.manage-memes .vote-up').on("click", _.bind(ns.ManageMemes.voteUp, ns.ManageMemes));
  });
})(window.MemeWeather);
