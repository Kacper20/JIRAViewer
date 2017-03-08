# Image Downloader & Cache assignment 

## Assumptions and thoughts

### Multiple requests at the same time
I didn't implement support for multiple requests at the same time, since it adds complexity do the task and I wouldn't be able to do it in specified time. I'm aware of wasting resource when doing so with current implementation and it shouldn't be hard to implement it properly.

### Cache
Cache that I implemented is most basic LRU cache, based on linked list and dictionary data structures. LinkedList was implemented in most simple way with only couple of needed operations.

I've added most basic tests of cache to check behaviour of policy.

There is a way for multiple types of caching - it's based on `Cacheable` protocol. Specific `Cacheable` instance is injected in `Downloader` instances.
Because of `Protocols with Associated Types` restriction I've built basic type eraser. Since I haven't got much time it's not written as good as in stdlib, but there's a way to hide `CacheableBox` and `CacheableBoxHelper` behind other level of indirection - something what stdlib does with `AnyIterator`.

`LRUCache` is built as `homogeneous` structure so it allows for storage of only type of objects per cache.
Thread safety is ensured by synchronization primitives(`NSLock` in this example).

### Multiple resource types
Since caches and downloaders are generic they should work with any type of resource as long as `Key` is `Hashable`.
Because of injection of `Cacheable` into downloaders there is possibility to mix cache policies with resource types - for example we could design for different than `LRU` policy for videos caching.

### Resource loading 
Since there are two ways of loading resource(synchronously and asynchronously) I've built two types of loaders and included creation samples in `Downloaders.swift` file. This file is only included in `iOS` target, since it's dependencies on `UIKit` structures.
