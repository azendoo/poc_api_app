Mongoid::Document.send(:include, ActiveModel::ForbiddenAttributesProtection)
ActionController::API.send :include, ActionController::StrongParameters
