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

  $('.image-select').on('click', function(e) {
    $(this).toggleClass('selected');
  });

  $('.push-btn').on('click', function(e) {
    var $this = $(this);
    $this.prop('disabled', true);

    var productId = $this.data('product-id');

    var selectedVariants = $('.variant-checkbox:checkbox:checked').map(function(i, elem) {
      return $(elem).data('variant-id');
    }).get();

    var selectedImages = $('.image-select.selected').map(function(i, elem) {
      return $(elem).data('image-id');
    }).get();

    $.ajax({
      url: '/products/' + productId + '/import',
      type: 'PUT',
      contentType: "application/json; charset=utf-8",

      data: JSON.stringify({
        variants: selectedVariants,
        images: selectedImages
      }),

      success: function(data) {
        $this.parents('.product').fadeOut();
      },

      error: function(xhr) {
        $this.prop('disabled', false);
        $this.parents('.product').find('.import-error').show();
      }
    });
  });
});

