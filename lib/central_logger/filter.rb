module CentralLogger
  module Filter
    def self.included(base)
      base.class_eval { around_filter :enable_central_logger }
    end

    def enable_central_logger
      return yield unless Rails.logger.respond_to?(:mongoize)

      Rails.logger.mongoize({
        :action         => action_name,
        :controller     => controller_name,
        :path           => request.path,
        :url            => request.url,
        :params         => request.filtered_parameters,
        :ip             => request.remote_ip
      }) { yield }
    end
  end
end
