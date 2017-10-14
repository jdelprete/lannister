// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on('turbolinks:load', function() {
  $.each(['ali-order', 'tracking'], function(i, category) {
    $(`.${category}-add, .${category}-edit`).on('click', function(e) {
      e.preventDefault();

      var $this = $(this);

      $this.hide();
      $this.siblings(`.${category}-link`).hide();
      $this.siblings(`.${category}-form`)
        .show()
        .children(`.${category}-input`).val($this.siblings(`.${category}-link`).text());
    });

    $(`.${category}-save`).on('click', function(e) {
      e.preventDefault();

      var $this = $(this);

      var $form = $this.parents(`.${category}-form`);
      var $link = $form.siblings(`.${category}-link`);
      
      var curValue = $link.text();
      var newValue = $this.siblings(`.${category}-input`).val();

      if (curValue != newValue) {
        var ajaxData = {};
        var resourceUrl = '';

        if (category == 'ali-order') {
          ajaxData['ali_order_number'] = newValue;

          resourceUrl = 'https://trade.aliexpress.com/order_detail.htm?orderId=' + newValue;
        } else {
          ajaxData['tracking_code'] = newValue;
          ajaxData['tracking_company'] = $this.siblings('.tracking-input').data('tracking-company');

          resourceUrl = 'https://track.aftership.com/' + newValue;
        }

        $.ajax({
          url: '/aliexpress_orders/' + $this.parents('.aliexpress-order').data('aliexpress-order-id'),
          type: 'PUT',
          data: ajaxData,

          success: function(data) {
            $form.hide();

            if (newValue) {
              $form.siblings(`.${category}-link`)
                .attr('href', resourceUrl)
                .text(newValue)
                .show();

              $form.siblings(`.${category}-edit`).show();
              $form.siblings(`.${category}-add`).hide();
            } else {
              $form.siblings(`.${category}-link`)
                .attr('href', 'javascript:;')
                .text('')
                .show();

              $form.siblings(`.${category}-add`).show();
              $form.siblings(`.${category}-edit`).hide();
            }
            
            toggleOrderStatus($this.parents('.aliexpress-order'));
          },

          error: function(xhr) {
          }
        });
      } else {
        $form.hide();
        $link.show();

        if (curValue) {
          $form.siblings(`.${category}-edit`).show();
        } else {
          $form.siblings(`.${category}-add`).show();
        }
      }
    });
  });

  $('.toggle-address-info').on('click', function(e) {
    e.preventDefault();
    $(this).parents('.order').find('.address-info').toggle();
  });

  $('.toggle-line-items > a').on('click', function(e) {
    e.preventDefault();

    var $aliExpressOrder = $(this).parents('.aliexpress-order');
    $aliExpressOrder.find('.line-items').toggle();
    $aliExpressOrder.find('.toggle-text').toggle();
    $aliExpressOrder.find('.toggle-chevron').toggleClass('rotate180btn');
  });

  $('.get-all-tracking-codes').on('click', function() {
    $('.get-tracking-code:visible').click();
  });
});

function toggleOrderStatus($order) {
  if ($order.find('.tracking-link').text()) {
    $order.find('.order-action').hide();
    $order.find('.order-status').hide();

    $order.find('.shipped-status').fadeIn();
    $order.find('.toggle-line-items').fadeIn();

    if ($order.find('.line-items').is(':visible'))
      $order.find('.toggle-line-items > a').click();
  } else if ($order.find('.ali-order-link').text()) {
    $order.find('.order-action').hide();
    $order.find('.order-status').hide();

    $order.find('.processing-status').fadeIn();
    $order.find('.get-tracking-code').fadeIn();

    if (!$order.find('.line-items').is(':visible'))
      $order.find('.toggle-line-items > a').click();
  } else {
    $order.find('.order-action').hide();
    $order.find('.order-status').hide();

    $order.find('.order-product').fadeIn();
    $order.find('.to-order-status').fadeIn();

    $order.find('.line-items').show();

    if (!$order.find('.line-items').is(':visible'))
      $order.find('.toggle-line-items > a').click();
  }
}
