class Bunny::Channel

  def persistent_publish(data, queue_name)
    default_exchange.publish(data, :routing_key => queue_name, persistent: true)
  end

end
