module ApplicationHelper

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  def current_panel
    controllers_in_admin_panel  = %w[developers job_sites phases suppliers products purchase_orders]
    controllers_in_logs         = %w[emails events]
    controllers_in_settings     = %w[settings users]
    controllers_in_home         = %w[home dashboard]

    if controllers_in_admin_panel.include? controller.controller_name
      return "admin"
    elsif controllers_in_logs.include? controller.controller_name  
      return "logs"
    elsif controllers_in_settings.include? controller.controller_name
      return "settings"
    else
      return ""
    end

  end

  def active_sub_menu(params)
    if current_panel == params
      return "active"
    else
      return ""
    end
  end

  def active_left_bar(params)
    if controller.controller_name == params
      return "class=active"
    elsif params == "job_sites" && job_site_show
      return "class=active"
    else
      return ""
    end
  end
end