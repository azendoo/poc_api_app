ActiveSupport.on_load(:active_model_serializers) do
  # Disable for all serializers (except ArraySerializer)
  ActiveModel::Serializer.root = false
  # Disable for ArraySerializer
  ActiveModel::ArraySerializer.root = false
end

# Support for Mongoid :
#Mongoid::Document.send(:include, ActiveModel::SerializerSupport)
#Mongoid::Criteria.delegate(:active_model_serializer, to: :to_a)
