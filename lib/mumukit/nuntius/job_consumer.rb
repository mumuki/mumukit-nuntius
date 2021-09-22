module Mumukit::Nuntius::JobConsumer

  extend Mumukit::Nuntius::TaskConsumer

  class Builder < Mumukit::Nuntius::TaskConsumer::Builder
    def job(key, &block)
      task(key, &block)
    end
  end

  class << self
    def builder
      Mumukit::Nuntius::JobConsumer::Builder
    end

    def handled_jobs
      handled_tasks
    end

    def tasks_type
      task_type.pluralize
    end

    def task_type
      'job'
    end

    def handle_job!(properties, body)
      handle_tasks! properties, body
    end

    def skip_process?(body)
      body[:data][:sender].try { |sender| sender != Mumukit::Nuntius.config.app_name }
    end
  end
end
