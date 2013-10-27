module JobSitesHelper
	
  def job_site_show
    return true if %w[phases lots].include? controller.controller_name
  end
end