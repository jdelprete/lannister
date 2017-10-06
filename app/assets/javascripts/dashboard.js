// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on('turbolinks:load', function() {
  var today = new Date();
  var sevenDaysAgo = new Date(today.getTime() - 604800000); // 604800000 ms == 7 days

  var $dateFromPicker = $('.date-from');
  var $dateToPicker = $('.date-to');

  $dateFromPicker.datepicker({
    autoHide: true,
    format: 'yyyy-mm-dd',
    date: sevenDaysAgo,
    autoPick: true
  }).on('pick.datepicker', function(e) {
    var dateFrom = e.date;
    var dateTo = $dateToPicker.datepicker('getDate');

    if (dateFrom.getTime() > dateTo.getTime()) {
      e.preventDefault();
      toastr.error('Start date cannot be later than the end date');
      return;
    }

    getChartData(dateFrom, dateTo);
  });

  $dateToPicker.datepicker({
    autoHide: true,
    format: 'yyyy-mm-dd',
    autoPick: true
  }).on('pick.datepicker', function(e) {
    var dateTo = e.date;
    var dateFrom = $dateFromPicker.datepicker('getDate');

    if (dateFrom.getTime() > dateTo.getTime()) {
      e.preventDefault();
      toastr.error('End date cannot be earlier than the start date');
      return;
    }

    getChartData(dateFrom, dateTo);
  });

  $dateFromPicker.add($dateToPicker).on('keydown', function(e) { e.preventDefault(); });
});

function getChartData(dateFrom, dateTo) {
  $.getJSON('/dashboard/json', {
    date_to: dateTo,
    date_from: dateFrom
  }, function(data) {
    dashboardChart.data.datasets[0].data = data.total_price_by_day;
    dashboardChart.data.datasets[1].data = data.total_cost_by_day;
    dashboardChart.data.datasets[2].data = data.order_count_by_day;

    dashboardChart.update();

    $('.dash-metric-sales').text(data.total_sales.toFixed(2));
    $('.dash-metric-orders').text(data.order_count);
    $('.dash-metric-costs').text(data.total_cost.toFixed(2));
    $('.dash-metric-earnings').text((data.total_sales - data.total_cost).toFixed(2));
  });
}
