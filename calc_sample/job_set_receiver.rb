class JobSetReceiver
  def initialize(id, topic, routing_key, job_count)
    @id = id
    @topic = topic
    @routing_key = routing_key
    @job_count = job_count
    @result = []
  end

  def receive_mode
    if @job_count > 0
      topic_receiver = TopicReceiver.new(@topic, @routing_key)
      topic_receiver.receive_mode do |msg|
        @job_count = @job_count - 1
        @result << msg
        puts "Jobs for id #{@id} left: #{@job_count}"
        topic_receiver.close unless @job_count > 0
      end
    end

    puts "#{@result.join('  \n')}"
  end
end
