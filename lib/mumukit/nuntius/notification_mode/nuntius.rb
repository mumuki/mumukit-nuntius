module Mumukit::Nuntius::NotificationMode
  class Nuntius
    def notify_event!(component, event, payload)
      payload.merge!(sender: component)
      notify! "events", { data: payload }, { type: event }
    end

    def notify!(exchange_name, data, opts={})
      channel, exchange = Mumukit::Nuntius::Connection.start_channel(exchange_name)
      exchange.notify(data.to_json, opts.merge(persistent: true))
      channel.close
    end

    def establish_connection
      Mumukit::Nuntius::Connection.establish_connection
    end
  end
end
