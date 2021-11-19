module Mumukit::Nuntius::JobConsumer

  extend Mumukit::Nuntius::TaskConsumer

  class Builder < Mumukit::Nuntius::TaskConsumer::Builder
    alias_method :job, :task
  end

  class << self

    alias_method :handled_jobs, :handled_tasks
    alias_method :handle_job!, :handle_tasks!

    def builder
      Mumukit::Nuntius::JobConsumer::Builder
    end

    def tasks_type
      task_type.pluralize
    end

    def task_type
      'job'
    end

    def skip_process?(body)
      body[:data][:sender].try { |sender| sender != Mumukit::Nuntius.config.app_name }
    end
  end
end
