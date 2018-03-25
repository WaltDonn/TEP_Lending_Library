module Api::V1
  class CredentialsController < ApiController
    before_action :doorkeeper_authorize!
    respond_to     :json

    #response = at.get('/api/v1/resource_owner', :params => {:nounce => 101})
    def resource_owner
      user = current_resource_owner
      nounce = params['nounce']
      respond_with user.attributes.merge(:nounce => nounce)
    end
  end
end