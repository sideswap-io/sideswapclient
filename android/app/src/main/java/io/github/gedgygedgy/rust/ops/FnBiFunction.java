package io.github.gedgygedgy.rust.ops;

import java.io.Closeable;
import java.util.function.BiFunction;

/**
 * Wraps a closure in a Java object.
 * <p>
 * Instances of this class cannot be obtained directly from Java. Instead, call
 * {@code jni_utils::ops::fn_bi_function()},
 * {@code jni_utils::ops::fn_mut_bi_function()}, or
 * {@code jni_utils::ops::fn_once_bi_function()} from Rust code to obtain an
 * instance of this class.
 */
public interface FnBiFunction<T, U, R> extends BiFunction<T, U, R>, Closeable {
    /**
     * Runs the closure associated with this object.
     * <p>
     * If the closure is a {@code std::ops::Fn} or {@code std::ops::FnMut},
     * calling this method twice will call the associated closure twice. If
     * the closure is a {@code std::ops::FnOnce}, the second call will return
     * {@code null}. If {@link close} has already been called, this method
     * returns {@code null}.
     */
    @Override
    public R apply(T t, U u);

    /**
     * Disposes of the closure associated with this object.
     * <p>
     * This method is idempotent - if it's called twice, the second call is a
     * no-op.
     */
    @Override
    public void close();
}
