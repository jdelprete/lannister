$(document).on('turbolinks:load', function() {
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

    var selectedVariants = $this.parents('.product').find('.variant-checkbox:checkbox:checked').map(function(i, elem) {
      return $(elem).data('variant-id');
    }).get();

    var selectedIndirectVariants = $this.parents('.product').find('.indirect-variant-checkbox:checkbox:checked').map(function(i, elem) {
      return $(elem).data('variant-id');
    }).get();

    var selectedImages = $this.parents('.product').find('.image-select.selected').map(function(i, elem) {
      return $(elem).data('image-id');
    }).get();

    $.ajax({
      url: '/products/' + productId + '/import',
      type: 'PUT',
      contentType: "application/json; charset=utf-8",

      data: JSON.stringify({
        variants: selectedVariants,
        indirect_variants: selectedIndirectVariants,
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

  $('.add-variants-btn').on('click', function(e) {
    $(this).siblings('.variants-modal').show();
  });

  $('.variants-modal').on('click', function(e) {
    $(this).hide();
  });

  $('.variants-modal > .modal-content').on('click', function(e) {
    e.stopPropagation();
  });

  $('.search-variants-input').livesearch({
    url: '/products/search',

    onSearch: function(data, inputElem) {
      var $modalBody = $(inputElem).parents('.modal-body');

      if (!data || !data.length)
        $modalBody.find('.search-variants-empty').show();
      else
        $modalBody.find('.search-variants-empty').hide();

      var productsHtml = '';

      for (var i = 0; i < data.length; i++) {
        var product = data[i];

        var productVariants = product['variants'];

        var variantsHtml = productVariants.reduce(function(variantsHtml, variant) {
          variantsHtml += `
            <li class="search-variants-variant">
              <input type="checkbox" class="search-variant-checkbox" data-variant-id="${variant.id}">
              <img src="${variant.image_src}" alt="${variant.title}">
              <span class="search-variants-result-title">${variant.title}</span>
              <span class="search-variants-result-cost">${variant.cost}</span>
            </li>`;

          return variantsHtml;
        }, '<ul>') + '</ul>';

        productsHtml += `
          <li class="search-variants-product">
            <img src="${product.image_src}" alt="${product.title}">
            <span class="search-variants-result-title">${product.title}</span>
            ${variantsHtml}
          </li>`;
      }

      $(inputElem).parents('.modal-body').find('.search-variants-results').html(productsHtml);
    }
  });

  $('.search-variants-results').on('click', '.search-variants-variant', function() {
    $(this).find('.search-variant-checkbox').click();
  });

  $('.search-variants-results').on('click', '.search-variant-checkbox', function(e) { e.stopPropagation(); });

  $('.add-variants-confirm-btn').on('click', function() {
    var $this = $(this);

    var numVariants = $this.parents('.variants-modal').find('.search-variant-checkbox:checked').each(function(i, elem) {
      var $elem = $(elem);

      var variantHtml = `
      <tr class="variant indirect-variant">
        <td>
          <input type="checkbox" class="indirect-variant-checkbox" data-variant-id="${$elem.data('variant-id')}" checked>
        </td>
        <td>
          <img src="${$elem.siblings('img').attr('src')}" class="border-img" style="max-width: 100px; max-height: 100px; margin: 5px;">
        </td>
        <td>
          ${$elem.siblings('.search-variants-result-title').text()}
        </td>
        <td>${$elem.siblings('.search-variants-result-cost').text()}</td>
      </tr>`;

      $elem.parents('.variants-tab-body').find('.indirect-variants-table tbody').append(variantHtml).show();
    }).length;

    if (numVariants)
      $this.parents('.variants-tab-body').find('.indirect-variants-table-wrap').removeClass('hide');

    $this.parents('.variants-modal').hide();
  });
});

