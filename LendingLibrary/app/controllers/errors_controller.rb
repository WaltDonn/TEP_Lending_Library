class ErrorsController < ApplicationController
  
  #https://mattbrictson.com/dynamic-rails-error-pages
  
  def not_found
    render(:status => 404)
  end

  def internal_server_error
    render(:status => 500)
  end
end
