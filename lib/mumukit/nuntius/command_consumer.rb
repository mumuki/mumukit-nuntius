module Mumukit::Nuntius::CommandConsumer

  class << self

    def start(name)
      Mumukit::Nuntius::Consumer.start "#{name}-commands" do |_delivery_info, _properties, body|
        begin
          choose_command(name, body.delete('type')).execute!(body)
        rescue NameError => e
          logger.info "Command #{name}-#{type} does not exists."
        rescue => e
          logger.info "Failed to proccess #{choose_command(name, type)}, error was: #{e}"
        end
      end
    end

    def choose_command(name, type)
      "#{name.capitalize}::Command::#{type}".constantize
    end
  end
end
