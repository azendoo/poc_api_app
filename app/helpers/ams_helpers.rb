# encoding: UTF-8
module AmsHelpers
  def namespace
    self.class.to_s.deconstantize
  end

  def serializer_key
    single_action? ? :serializer : :each_serializer
  end

  def serializer
    namespaced_serializer || active_model_serializer
  end

  def namespaced_serializer
    "#{namespace}::#{serializer_name}".constantize rescue nil
  end

  def active_model_serializer
    serializer_name.constantize rescue nil
  end

  def default_serializer_options
    {
      serializer_key => serializer
    }
  end

#  def default_serializer
#    ActiveModel::DefaultSerializer
#  end

  def serializer_name
    class_name = self.class.name.demodulize
    class_name.demodulize.sub(/Controller$/, '').singularize + 'Serializer'
  end

  def single_action?
    !collection_actions.include?(params[:action])
  end

  def collection_actions
    %w(index)
  end
end
