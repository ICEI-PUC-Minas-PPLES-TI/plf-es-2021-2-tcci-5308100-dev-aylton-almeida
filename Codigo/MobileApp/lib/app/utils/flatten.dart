List<T> flatten<T>(Iterable<Iterable<T>> list) =>
    [for (final subList in list) ...subList];
