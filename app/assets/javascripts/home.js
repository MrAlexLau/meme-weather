(function (ns) {
  ns.Home = {
    formattedDescription: function (weatherStatus) {
      var location = weatherStatus.location_name,
          conditions = weatherStatus.weather_conditions,
          temp = weatherStatus.temperature,
          tempUnit = weatherStatus.temperature_unit;

      return "" + location + " is " + temp + "&deg; " + tempUnit + " and conditions are " + conditions;
    },

    startWorking: function () {
      $('.loader').show();
    },

    stopWorking: function () {
      $('.loader').hide();
    },

    formIsValid: function (value) {
      return (value.length > 1);
    },

    showFlash: function (message) {
      $('.flash-message').html(message);
      $('.flash').show();
    },

    hideFlash: function (message) {
      $('.flash').hide();
    },

    fetchWeather: function (term) {
      // Note that the theme is hardcoded as "cats". TODO: abstract this
      var url = "/api/weather_memes/search?location=" + term + "&theme=cat";

      $.ajax(url)
        .done(_.bind(function(result) {
          $('.results').fadeIn();
          $('.results .description').html(this.formattedDescription(result));
          $('.results .meme').attr('src', result.meme_image_link);
        }, this))
        .fail(_.bind(function() {
          this.showFlash("Could not fetch the weather.");
        }, this))
        .always(_.bind(function(result) {
          this.stopWorking();
        }, this));
    },

    onSubmit: function (e) {
      var searchTerm = $(".location").val();

      e.preventDefault();
      document.activeElement.blur(); // hide the ios keyboard

      if (this.formIsValid(searchTerm)) {
        this.hideFlash();
        this.startWorking();
      }
      else {
        this.showFlash("Please enter a location.");
        return;
      }

      this.fetchWeather(searchTerm);
    },
  }

  $(function() {
    $('.location-form').on("submit", _.bind(ns.Home.onSubmit, ns.Home));
  });
})(window.MemeWeather);
