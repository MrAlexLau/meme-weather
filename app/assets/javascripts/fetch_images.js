(function (ns) {
  ns.FetchImages = {
    selector: function (selectorName) {
      var parent = '.fetch-images',
          map = {
            'search-box': '.search-box',
            'search-form': '.fetch-memes-form',
            'no-results': '.no-results',
            'force-fetch': '.force-fetch',
            'results-summary': '.results-summary',
            'num-images': 'select[name=num_images]'
          };

      return $(parent + ' ' + map[selectorName]);
    },

    bindEvents: function () {
      this.selector('search-form').on('submit', _.bind(this.render, this));
      this.selector('force-fetch').on('click', _.bind(this.fetchMore, this));
    },

    fetchMore: function (e) {
      var url = '/memes/fetch_more',
          filters = {
            tag_list: this.selector('search-box').val(),
            num_images: this.selector('num-images').val(),
          };

      e.preventDefault();

      this.selector('no-results').hide();

      $.ajax({
        url: url,
        method: 'POST',
        data: filters
      })
      .done(_.bind(function(results) {
        console.log('images fetched')
      }, this))
      .fail(_.bind(function() {
        alert("Could not fetch more images.");
      }, this));
    },

    render: function (e) {
      var url = '/memes/search',
          filters = {
            hide_voting: 1,
            tag_list: this.selector('search-box').val()
          };

      if (e) {
        e.preventDefault();
      }

      this.selector('no-results').hide();
      this.selector('results-summary').show();

      $.ajax({
        url: url,
        data: filters
      })
      .done(_.bind(function(results) {
        this.selector('force-fetch').show();
        if ($('.meme-list').html().length === 0) {
          this.selector('no-results').show();
        }
      }, this))
      .fail(_.bind(function() {
        alert("Could not load images.");
      }, this));
    },
  };

  $(function() {
    if ($('.fetch-images').length > 0) {
      ns.FetchImages.bindEvents();

      // If a search term is present, load memes.
      if (ns.FetchImages.selector('search-box').val().length > 0) {
        ns.FetchImages.render();
      }
    }
  });
})(window.MemeWeather);
