module ApplicationHelper
  def icon_id
    case controller_name
    when 'products'
      'icon-sidebar-products'
    when 'dashboard'
      'icon-dashboard'
    when 'orders'
      'icon-sidebar-file'
    end
  end

  def title
    case controller_name
    when 'products'
      'Products'
    when 'dashboard'
      'Dashboard'
    when 'orders'
      'Orders'
    end
  end
end
