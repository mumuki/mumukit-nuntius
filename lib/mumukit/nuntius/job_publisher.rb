module Mumukit::Nuntius::JobPublisher

  class << self

    def publish(job, payload)
      payload.merge!(sender: Mumukit::Nuntius.config.app_name)
      Mumukit::Nuntius::Publisher.publish "jobs", {data: payload}, {type: job}
    end

  end
end
