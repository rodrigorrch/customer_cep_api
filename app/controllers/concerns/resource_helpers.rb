module ResourceHelpers
  extend ActiveSupport::Concern

  private

  def resource_class
    @resource_class ||= controller_path.classify.demodulize.constantize
  end

  def load_resource
    @resource = resource_class.preload(resource_includes).find(params.require(:id))
  end

  def load_resource_collection
    resource_class.preload(resource_includes)
  end

  def resource_includes
    {}
  end
end