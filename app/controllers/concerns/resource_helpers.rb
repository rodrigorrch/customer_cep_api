module ResourceHelpers
  extend ActiveSupport::Concern

  attr_accessor :resource

  private

  def resource_class
    @resource_class ||= controller_path.classify.demodulize.constantize
  end

  def load_resource
    @resource = resource_class.preload(resource_includes).find(params.require(:id))
  rescue ActiveRecord::RecordNotFound
    message = "No address was found for id #{params.require(:id)}."
    render  json: { error: message }, status: :not_found
  end

  def load_resource_collection
    resource_class.preload(resource_includes)
  end

  def resource_includes
    {}
  end
end
