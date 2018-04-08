module Api::V1
  class CredentialsController < ApiController
    before_action :doorkeeper_authorize!
    respond_to     :json

    #response = at.get('/api/v1/resource_owner', :params => {:nounce => nounce})
    #Nounce = SecureRandom.hex(32)
    def resource_owner

      if(params['nounce'].length != 64)
        response = {
          error: "Nounce not set correctly"
        }
      else
        user = current_resource_owner
        response = {
            id: user.id,
            first_name: user.first_name,
            last_name: user.last_name,
            email: user.email,
            role: user.role,
            nounce: params['nounce']
        }
      end

      respond_with response
    end
  end
end