module Concerns
  module HasArray
    extend ActiveSupport::Concern

    module ClassMethods
      def has_array(plural, class_name:)
        name        = plural.to_s.singularize.to_sym
        klass       = class_name.constantize
        ids         = :"#{name}_ids"
        query       = :"#{name}?"
        add         = :"add_#{name}"
        add_id      = :"add_#{name}_id"
        remove      = :"remove_#{name}"
        remove_id   = :"remove_#{name}_id"
        will_change = :"#{ids}_will_change!"
        clean_up    = :"clean_up_#{ids}"

        define_method(plural) do
          klass.where id: send(ids)
        end

        define_method(query) do |user|
          send(ids).include? user.id
        end

        define_method(add) do |user, raise_exception: false|
          send(add_id, user.id)
          if raise_exception
            save!
          else
            save
          end
        end

        define_method(remove) do |user, raise_exception: false|
          send(remove_id, user.id)
          if raise_exception
            save!
          else
            save
          end
        end

        define_method(add_id) do |user_id|
          send(will_change)
          send(ids).push user_id
          send(clean_up)
        end

        define_method(remove_id) do |user_id|
          send(will_change)
          send(ids).delete user_id
          send(clean_up)
        end

        define_method(clean_up) do
          send(ids).compact!
          send(ids).uniq!
        end
      end
    end
  end
end
