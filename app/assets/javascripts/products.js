$(function() {
  $('.product-tab').on('click', function(e) {
    e.preventDefault();

    var $tabLink = $(this);

    if ($tabLink.parent('li').hasClass('active')) 
      return;

    var tabBodyClass = $tabLink.data('tab-body-class');

    $tabLink.parents('.nav-tabs').find('.product-tab').parent('li').removeClass('active');
    $tabLink.parent('li').addClass('active');

    $tabLink.parents('.product').find('.tabs-body').hide();
    $tabLink.parents('.product').find('.' + tabBodyClass).show();
  });
});

