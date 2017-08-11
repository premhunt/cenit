module RailsAdmin
  module Config
    Model.class_eval do

      def dashboard_group_path
        unless @dashboard_group_path
          compute_dashboard_groups(@dashboard_group_path = [])
        end
        @dashboard_group_path
      end

      def compute_dashboard_groups(path = [], nodes = RailsAdmin::Config.dashboard_groups)
        nodes.each do |n|
          if n.is_a?(String)
            return true if abstract_model.model_name == n
          elsif n.is_a?(Hash)
            path << n[:param]
            return true if n[:label] == navigation_label
            return true if compute_dashboard_groups(path, n[:sublinks] || [])
            path.pop
          end
        end
        false
      end

      register_instance_option :visible do
        (controller = (bindings && bindings[:controller])).nil? ||
          ((model_config = controller.instance_variable_get(:@model_config)) && model_config.navigation_label == navigation_label) ||
          ((g = controller.params[:group]) && dashboard_group_path.include?(g))
      end

      def ready
        self
      end

      register_instance_option :public_access? do
        Ability::CROSSING_MODELS_WITH_ORIGIN.include?(abstract_model.model) rescue false
      end

      Actions.all.each do |action|
        instance_eval "register_instance_option(:#{action.key}_template_name) { :#{action.key} }"
        instance_eval "register_instance_option(:#{action.key}_link_icon) { nil }"
      end

      register_instance_option :template_name do
        if (action = bindings[:action])
          send("#{action.key}_template_name")
        end
      end

      register_instance_option :dashboard_group_label do
        'Undefined'
      end

      register_instance_option :show_in_dashboard do
        true
      end

      register_instance_option :label_navigation do
        label_plural
      end

      def contextualized_label(context = nil)
        label
      end

      def contextualized_label_plural(context = nil)
        label_plural
      end

      register_instance_option :extra_associations do
        []
      end
      register_instance_option :wizard_steps do
        {}
      end

      register_instance_option :current_step do
        0
      end

      register_instance_option :search_associations do
        []
      end
    end
  end
end
