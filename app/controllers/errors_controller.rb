class ErrorsController < ApplicationController
  
  #https://mattbrictson.com/dynamic-rails-error-pages
  
  def not_found
    render(:status => 404)
  end

  def internal_server_error
    render(:status => 500)
  end

  def access_denied
    render(:status => 403)
  end
  
  def routing
    unless params[:a].nil?
      logger.info "500 Error with: '#{params[:a]}'"
    end
    render(:status => 404)
  end
  
end
