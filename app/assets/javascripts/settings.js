(function (ns) {
  ns.Settings = {
    load: function () {
      var theme = this.selectedTheme();
      $('.btn-group-theme .btn[data-value=' + theme + ']').click();
    },

    selector: function (selectionString) {
      var mappings = {
        "theme": "input[name='setting[theme]']",
      };

      return $(mappings[selectionString]);
    },

    toggleSettingsPane: function (e) {
      var $icon = $(e.currentTarget).find('i');

      e.preventDefault();

      $icon.toggleClass('fa-angle-down');
      $icon.toggleClass('fa-angle-up');

      $('.settings').slideToggle();
    },

    selectedTheme: function () {
      return this.selector("theme").val();
    },

    selectTheme: function (e) {
      var $target = $(e.currentTarget);
      e.preventDefault();

      $('.btn-group-theme .btn').removeClass('btn-info');
      $target.addClass('btn-info');

      this.selector("theme").val($target.data('value'));
    }
  }

  $(function() {
    $('.settings-trigger').on("click", _.bind(ns.Settings.toggleSettingsPane, ns.Settings));
    $('.btn-group-theme .btn').on("click", _.bind(ns.Settings.selectTheme, ns.Settings));

    ns.Settings.load();
  });
})(window.MemeWeather);
