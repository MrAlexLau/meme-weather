$(function() {
  var formattedDescription = function (weatherInfo) {
    var location = weatherInfo.location_name,
        conditions = weatherInfo.weather_conditions,
        temp = weatherInfo.temperature,
        tempUnit = weatherInfo.temperature_unit;

    return "" + location + " is " + temp + "&deg; " + tempUnit + " and " + conditions;
  };

  var fetchWeather = function (e) {
    // Note that the theme is hardcoded as "cats".
    // TODO: abstract this
    var value = $(".location").val(),
        url = "/api/weather_memes/search?location=" + value + "&theme=cat";

    e.preventDefault();

    $.ajax(url)
      .done(function(result) {
        $('.result .description').html(formattedDescription(result));
        $('.result .meme').attr('src', result.meme_image_link);
      })
      .fail(function() {
        console.log( "error" );
      })
      .always(function() {
        console.log( "complete" );
      });
  };

  $('.location-form').on("submit", fetchWeather);
});
