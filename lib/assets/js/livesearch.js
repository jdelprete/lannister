/*
{
  delay: ,
  searchParamKey: ,
  url: ,
  onSearch:
  pre: 
}
 */

(function($) {
  $.fn.livesearch = function(options) {
    var $inputs = this.filter('input');

    $inputs.each(function(i, inputElem) {
      var timer = null;
      var previousSearchValue = '';

      $(this).on('keyup', function() {
        clearTimeout(timer);
        var ms = options.delay || 400;
        var self = this;

        if (options.before)
          options.before(inputElem);

        timer = setTimeout(function() {
          var searchValue = self.value;

          if (previousSearchValue == searchValue)
            return;

          previousSearchValue = searchValue;

          var data = {};
          data[options.searchParamKey || 'query'] = searchValue;

          $.ajax({
            dataType: "json",
            url: options.url,
            data: data,
            success: function(data) {
              options.onSearch(data, inputElem);
            }
          });
        }, ms);
      });
    });

    return this;
  };
}(jQuery));
