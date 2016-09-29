module Mumukit::Nuntius::CommandConsumer

  class << self

    def start(name)
      Mumukit::Nuntius::Consumer.start "#{name}-commands" do |_delivery_info, _properties, body|
        begin
          choose_command(name, body['type']).execute!(body['data'])
        rescue NameError => e
          Mumukit::Nuntius::Logger.info "Command #{name}-#{type} does not exists."
        rescue => e
          Mumukit::Nuntius::Logger.info "Failed to proccess #{choose_command(name, type)}, error was: #{e}"
        end
      end
    end

    def choose_command(name, type)
      "#{name.capitalize}::Command::#{type}".constantize
    end
  end
end
