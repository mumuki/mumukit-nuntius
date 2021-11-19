module Mumukit::Nuntius::TaskConsumer

  class Builder
    def initialize
      @handlers = {}
    end

    def task(key, &block)
      @handlers[key] = with_database_reconnection &block
    end

    def build
      @handlers.with_indifferent_access
    end

    private

    def with_database_reconnection(&block)
      return block unless defined? ActiveRecord
      proc do |*args|
        ActiveRecord::Base.connection_pool.with_connection do
          block.call(*args)
        end
      end
    end

  end

  def handlers
    @@handlers ||= {}
  end

  def handle(&block)
    register_handlers! builder.new.tap { |it| it.instance_eval(&block) }.build
  end

  def handled_tasks
    handlers.keys
  end

  def register_handlers!(handlers)
    @@handlers = handlers
  end

  def start!
    queue_name = "#{Mumukit::Nuntius.config.app_name}-#{tasks_type}"
    Mumukit::Nuntius::Consumer.start queue_name, tasks_type do |_delivery_info, properties, body|
      handle_tasks!(properties, body)
    end
  end

  def handles?(task)
    handlers.include? task
  end

  def handle_tasks!(properties, body)
    return if skip_process? body
    task = properties[:type]
    if handles? task
      handlers[task].call body[:data].except(:sender)
    else
      log_unknown_task task
    end
  rescue => e
    log_exception(task, e, body[:data])
  end

  def log_unknown_task(task)
    Mumukit::Nuntius::Logger.info "Unhandled #{task_type}: #{task} does not exists."
  end

  def log_exception(task, e, body)
    Mumukit::Nuntius::Logger.error "Failed to proccess #{task}, error was: #{e}, body was: #{body}"
  end
end
