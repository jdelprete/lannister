module ApplicationHelper
  def icon_id_from_title(title)
    case title
    when 'Manage Products'
      'icon-sidebar-products'
    when 'Dashboard'
      'icon-dashboard'
    when 'Orders'
      'icon-sidebar-file'
    end
  end
end
