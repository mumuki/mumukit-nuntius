module Mumukit::Nuntius::EventConsumer

  extend Mumukit::Nuntius::TaskConsumer

  class Builder < Mumukit::Nuntius::TaskConsumer::Builder
    def event(key, &block)
      task(key, &block)
    end
  end

  class << self
    def builder
      Mumukit::Nuntius::EventConsumer::Builder
    end

    def handled_events
      handled_tasks
    end

    def tasks_type
      task_type.pluralize
    end

    def task_type
      'event'
    end

    def handle_event!(properties, body)
      handle_tasks! properties, body
    end

    def skip_process?(body)
      body[:data][:sender] == Mumukit::Nuntius.config.app_name
    end
  end
end
