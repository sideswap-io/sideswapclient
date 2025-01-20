/// Implements a ALL constant of type &'static [EnumName] that includes all variants
#[macro_export]
macro_rules! define_enum {
    ($name:ident { $($variant:ident),+ $(,)? }) => {
        #[derive(Debug, Clone, Copy, Hash, PartialEq, Eq, PartialOrd, Ord)]
        pub enum $name {
            $($variant),+
        }

        impl $name {
            pub const ALL: &'static [$name] = &[
                $($name::$variant),+
            ];
        }
    };
}
