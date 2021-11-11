module Mumukit::Nuntius::EventConsumer

  extend Mumukit::Nuntius::TaskConsumer

  class Builder < Mumukit::Nuntius::TaskConsumer::Builder
    alias_method :event, :task
  end

  class << self

    alias_method :handled_events, :handled_tasks
    alias_method :handle_event!, :handle_tasks!

    def builder
      Mumukit::Nuntius::EventConsumer::Builder
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
