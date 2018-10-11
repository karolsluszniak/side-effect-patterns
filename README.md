# side-effect-patterns

A showcase of different approaches towards flow control around synchronous side-effects, without and with the use of eventing.

- `call` - basic flow in which side-effects are directly triggered from origin
- `pubsub` - interested parties aka. handlers subscribe to events emitted by origin
- `observer` - origin trigger signals that emit to observers they're aware of

Here's what you can find in this repo:

- `lib` - basic library implementations for `pubsub` and `observer` patterns
- `examples` - real-life cases for all presented approaches
  - `basic` - plain implementation
  - `create_invoice` - more complex case inspired by DDD

## Usage

In order to run examples, run the following commands:

```
ruby examples/basic/run.rb
ruby examples/create_invoice/run.rb
```

In order to compare specific approaches, use your favorite diffing tool.
