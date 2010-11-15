module CentralLogger
  module Filter
    def self.included(base)
      base.class_eval { around_filter :enable_central_logger }
    end

    def enable_central_logger
      return yield unless Rails.logger.respond_to?(:mongoize)

      return yield if defined?(CENTRAL_LOGGER_IGNORES) && CENTRAL_LOGGER_IGNORES.include?("#{controller_name}##{action_name}")

      # make sure the controller knows how to filter its parameters (Rails 3, 2, respectively)
      f_params = case
                   when request.respond_to?(:filtered_parameters) then request.filtered_parameters
                   when respond_to?(:filter_parameters) then filter_parameters(params)
                   else params
                 end
      Rails.logger.mongoize({
        :action         => action_name,
        :controller     => controller_name,
        :path           => request.path,
        :url            => request.url,
        :params         => f_params,
        :ip             => request.remote_ip
      }) { yield }
    end
  end
end