# ``PDGraphics/PGBayerPatternCache``

The cache conforms to the `Collection` protocol and can be used like a
read-only collection of bit patterns. When accessing values, they will be
converted into ``PGColor`` values with an always-draw mask (see
``PGPatternMaskAlwaysDraw``).

Patterns in the cache can be accessed in one of two ways: a direct index
value, or by nearest brightness:

```swift
let cache = PGBayerPatternCache()

let iPattern = cache[127]
let fPattern = cache[0.5] // Equivalent to PGColor.dithered(by: 0.5)
```

The cache is best used in performance-critical applications where
computing brightness levels and their appropriate colors might be costly
in a render loop.

> Tip: For faster access, consider storing the cache in an easily
> accessible place. For example, if you are creating a 3D scene renderer,
> consider storing the cache in the renderer and initialize it along with
> the rest of the renderer:
>
> ```swift
> class MyRenderer {
>     let cache: PGBayerPatternCache
>     init(...) {
>         self.cache = PGBayerPatternCache()
>         ...
>     }
> }
> ```
