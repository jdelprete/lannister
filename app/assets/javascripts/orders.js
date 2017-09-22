$(function() {
  $('.ali-order-add, .ali-order-edit').on('click', function(e) {
    e.preventDefault();

    var $this = $(this);

    $this.hide();
    $this.siblings('.ali-order-link').hide();
    $this.siblings('.ali-order-form')
      .show()
      .children('.ali-order-input').val($this.siblings('.ali-order-link').text());
  });

  $('.ali-order-save').on('click', function(e) {
    e.preventDefault();

    var $this = $(this);
    var $aliOrderForm = $this.parents('.ali-order-form');
    var $aliOrderLink = $aliOrderForm.siblings('.ali-order-link');
    
    var orderId = $this.parents('.order').data('order-id');
    var curAliOrderNumber = $aliOrderLink.text();
    var newAliOrderNumber = $this.siblings('.ali-order-input').val();

    if (curAliOrderNumber != newAliOrderNumber) {
      $.ajax({
        url: '/orders/' + orderId,
        type: 'PUT',

        data: {
          ali_order_number: newAliOrderNumber
        },

        success: function(data) {
          $aliOrderForm.hide();

          if (newAliOrderNumber) {
            $aliOrderForm.siblings('.ali-order-link')
              .attr('href', 'http://trade.aliexpress.com/order_detail.htm?orderId=' + newAliOrderNumber)
              .text(newAliOrderNumber)
              .show();

            $aliOrderForm.siblings('.ali-order-edit').show();
            $aliOrderForm.siblings('.ali-order-add').hide();
          } else {
            $aliOrderForm.siblings('.ali-order-link')
              .attr('href', 'javascript:;')
              .text('')
              .show();

            $aliOrderForm.siblings('.ali-order-add').show();
            $aliOrderForm.siblings('.ali-order-edit').hide();
          }

          toggleOrderStatus($this.parents('.order'));
        },

        error: function(xhr) {
        }
      });
    } else {
      $aliOrderForm.hide();
      $aliOrderLink.show();

      if (curAliOrderNumber) {
        $aliOrderForm.siblings('.ali-order-edit').show();
      } else {
        $aliOrderForm.siblings('.ali-order-add').show();
      }
    }
  });
});

function toggleOrderStatus($order) {
  if ($order.find('.ali-order-link').text()) {
    $order.find('.order-product').hide();
    $order.find('.to-order-status').hide();

    $order.find('.processing-status').fadeIn();
    $order.find('.get-tracking-code').fadeIn();
  } else {
    $order.find('.processing-status').hide();
    $order.find('.get-tracking-code').hide();

    $order.find('.order-product').fadeIn();
    $order.find('.to-order-status').fadeIn();
  }
}
