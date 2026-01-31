# ``PDFoundation/Measurement``

The Measurement object is generally used to manually profile a given
amount of work when the sampler cannot be used. Measurements can be
recorded either seconds or milliseconds.

```swift
let someWorkTime = Measurement("Performing some work", in: .milliseconds)
defer { someWorkTime.record() }
...
```

## Measuring multiple iterations

Measurement can work under two modes: a single scoped iteration, and
multiple iterations with accumulated time. To show an accumulated time
over a certain amount of runs, use ``checkpoint()``:

```swift
let someWorkTime = Measurement("Performing some work", in: .milliseconds)
for _ in 1...99 {
   someWorkTime.reset()
   doSomeHeavyWork()
   someWorkTime.checkpoint()
}
someWorkTime.record()
```

To display the times as an average rather than a total accumulation,
set `displayTimesAsAverages` in ``record(displayTimesAsAverages:)``:

```swift
someWorkTime.record(displayTimesAsAverages: true)
```

## Output formats

Measurements can be displayed as a pretty-printed statement or by tab
separated values. To set the output format, provide the `outputFormat`
argument in the initializer:

```swift
let someWorkTime = Measurement("Performing some work", outputFormat: .tsv)
```

## Topics

### Recording output

- ``record(displayTimesAsAverages:)``
- ``OutputFormat``

### Measuring multiple iterations

- ``checkpoint()``
- ``checkpoints``
- ``accumulatedTime``
- ``reset()``
