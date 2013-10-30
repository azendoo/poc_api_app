# encoding: utf-8
module Api
  # XXX:
  # ActiveModel::Serializer customizations in order to
  # handle Serializers versioning via namespaces. That huge monkey patching
  # was not tested on the recent refactoring of AMS project by spastorino, but
  # perfectly worked before. See the following link for more informations on
  # recent AMS changes :
  # http://blog.wyeworks.com/2013/10/15/active_model_serializers_rewrite/

  module Serializer
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
end
