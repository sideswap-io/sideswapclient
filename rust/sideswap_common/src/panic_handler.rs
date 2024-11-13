pub fn install_panic_handler() {
    std::panic::set_hook(Box::new(|info| {
        log::error!("panic: {info}");
        eprint!("panic: {info}");
        std::process::abort();
    }));
}
