if Rails::VERSION::MAJOR == 3
  require 'central_logger/initializer_mixin'

  class Railtie < Rails::Railtie
    include CentralLogger::InitializerMixin

    initializer :initialize_central_logger, :after => :initialize_logger do
      app_config = Rails.application.config
      Rails.logger = config.logger = create_logger(app_config,
                                                   app_config.paths.log.to_a.first)
    end
  end
end

