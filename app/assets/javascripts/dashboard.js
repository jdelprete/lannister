// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on('turbolinks:load', function() {
  var today = new Date();
  var sevenDaysAgo = new Date(today.getTime() - daysToMillis(7));

  var $dateFromPicker = $('.date-from');
  var $dateToPicker = $('.date-to');
  var $chartDropdown = $('.chart-dropdown');

  var dateFromDropdown = false; // used to prevent datepicker change from sending ajax request when dropdown is used
  var dateToDropdown = false; // used to prevent datepicker change from sending ajax request when dropdown is used

  $dateFromPicker.datepicker({
    autoHide: true,
    format: 'yyyy-mm-dd',
    date: sevenDaysAgo,
    autoPick: true
  }).on('pick.datepicker', function(e) {
    if (dateFromDropdown) {
      dateFromDropdown = false;
      return;
    }

    var dateFrom = e.date;
    var dateTo = $dateToPicker.datepicker('getDate');

    if (dateFrom.getTime() > dateTo.getTime()) {
      e.preventDefault();
      toastr.error('Start date cannot be later than the end date');
      return;
    }

    $chartDropdown.val('custom').change();
    getChartData(dateFrom, dateTo);
  });

  $dateToPicker.datepicker({
    autoHide: true,
    format: 'yyyy-mm-dd',
    autoPick: true
  }).on('pick.datepicker', function(e) {
    if (dateToDropdown) {
      dateToDropdown = false;
      return;
    }

    var dateTo = e.date;
    var dateFrom = $dateFromPicker.datepicker('getDate');

    if (dateFrom.getTime() > dateTo.getTime()) {
      e.preventDefault();
      toastr.error('End date cannot be earlier than the start date');
      return;
    }

    $chartDropdown.val('custom').change();
    getChartData(dateFrom, dateTo);
  });

  $dateFromPicker.add($dateToPicker).on('keydown', function(e) { e.preventDefault(); });

  $('.chart-dropdown').on('change', function() {
    var dateRange = $(this).val();
    var today = new Date();
    var dateFrom = new Date();
    var dateTo = new Date();

    switch (dateRange) {
      case 'today':
        break;
      case 'yesterday':
        dateFrom = new Date(today.getTime() - daysToMillis(1));
        dateTo = dateFrom;
        break;
      case 'last_7':
        dateFrom = new Date(today.getTime() - daysToMillis(7));
        break;
      case 'last_30':
        dateFrom = new Date(today.getTime() - daysToMillis(30));
        break;
      case 'last_90':
        dateFrom = new Date(today.getTime() - daysToMillis(90));
        break;
      case 'week_to_date':
        dateFrom = new Date(today.getTime() - daysToMillis(today.getDay()));
        break;
      case 'month_to_date':
        dateFrom.setDate(1);
        break;
      case 'quarter_to_date':
        dateFrom.setMonth((Math.floor((today.getMonth() + 3) / 3) - 1) * 3);
        dateFrom.setDate(1);
        break;
      case 'year_to_date':
        dateFrom.setMonth(0);
        dateFrom.setDate(1);
        break;
      default:
        return;
        break;
    }

    dateFromDropdown = true;
    dateToDropdown = true;

    $dateFromPicker.datepicker('setDate', dateFrom);
    $dateToPicker.datepicker('setDate', dateTo);

    getChartData(dateFrom, dateTo);
  });
});

function getChartData(dateFrom, dateTo) {
  $.getJSON('/dashboard/json', {
    date_to: dateTo,
    date_from: dateFrom
  }, function(data) {
    dashboardChart.data.datasets[0].data = data.total_cost_by_day;
    dashboardChart.data.datasets[1].data = data.total_price_by_day;
    dashboardChart.data.datasets[2].data = data.order_count_by_day;

    dashboardChart.update();

    $('.dash-metric-sales').text(data.total_sales.toFixed(2));
    $('.dash-metric-orders').text(data.order_count);
    $('.dash-metric-costs').text(data.total_cost.toFixed(2));
    $('.dash-metric-earnings').text((data.total_sales - data.total_cost).toFixed(2));
  });
}

function daysToMillis(numDays) {
  return numDays * 24 * 60 * 60 * 1000;
}
