package main
import (
  "github.com/streadway/amqp"
  "log"
)

const (
  ConnectionString = "amqp://guest:guest@localhost:5672/"
  TaskQueueName = "producer-to-calculator"
)

func main() {
  conn, err := amqp.Dial(ConnectionString)
  failOnError(err)
  defer conn.Close()
  ch, err := conn.Channel()
  failOnError(err)
  defer ch.Close()
  taskQueue, err := ch.QueueDeclare(
    TaskQueueName, // name
    false, // durable
    false, // delete when unused
    false, // exclusive
    false, // no-wait
    nil, // arguments
  )
  if err != nil {
    panic(err)
  }
  publishing := amqp.Publishing{
    DeliveryMode: amqp.Persistent,
    ContentType: "text/plain",
    Body: []byte("foobarbaz"),
  }
  ch.Publish(
    "", // exchange
    taskQueue.Name, // routing key
    false, // mandatory
    false, // immediate
    publishing,
  )
  log.Printf(" [*] Waiting for messages. To exit press CTRL+C")
}

// func processMessage(d amqp.Delivery, ch *amqp.Channel) error {
//   resultQueue, err := ch.QueueDeclare(
//     ResultQueueName, // name
//     false, // durable
//     false, // delete when unused
//     false, // exclusive
//     false, // no-wait
//     nil, // arguments
//   )
//   if err != nil { return err }
//     publishing := amqp.Publishing{
//     DeliveryMode: amqp.Persistent,
//     ContentType: "text/plain",
//     Body: []byte(d.Body),
//   }
//   return ch.Publish(
//     "", // exchange
//     resultQueue.Name, // routing key
//     false, // mandatory
//     false, // immediate
//     publishing,
//   )
// }

func failOnError(err error) {
  if err != nil {
    log.Fatalf("FATAL ERROR:\n%v", err)
    panic(err)
  }
}
