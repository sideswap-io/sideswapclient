use std::fmt;

#[derive(Copy, Clone, Debug, PartialEq, Eq, Hash)]
pub(crate) enum AssetsOrIcons {
    Assets,
    Icons,
}

impl fmt::Display for AssetsOrIcons {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        f.write_str(match self {
            Self::Assets => "assets",
            Self::Icons => "icons",
        })
    }
}

impl AssetsOrIcons {
    pub(crate) const fn endpoint(&self) -> &'static str {
        match self {
            Self::Assets => "/index.json",
            Self::Icons => "/icons.json",
        }
    }

    pub(crate) const fn len() -> usize {
        2
    }
}
