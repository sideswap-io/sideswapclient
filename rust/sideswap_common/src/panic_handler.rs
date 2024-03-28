pub fn install_panic_handler() {
    std::panic::set_hook(Box::new(|i| {
        log::error!("panic: {:?}", i);
        eprint!("panic: {:?}", i);
        std::process::abort();
    }));
}
