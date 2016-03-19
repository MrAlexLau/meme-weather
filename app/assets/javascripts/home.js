$(function() {
  var formattedDescription = function (weatherInfo) {
    var location = weatherInfo.location_name,
        conditions = weatherInfo.weather_conditions,
        temp = weatherInfo.temperature,
        tempUnit = weatherInfo.temperature_unit;

    return "" + location + " is " + temp + " " + tempUnit + " and " + conditions;
  };

  var fetchWeather = function (e) {
    var value = $(".location").val();
    var url = "/api/weather_memes/search?location=" + value;

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
