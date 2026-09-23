/// The page content area a desktop page is laid out in, at the two window
/// heights of ADR-0014 decision 11.
///
/// The content area is the client height minus the 114 px of fixed page
/// chrome the issue's arithmetic names (top toolbar 34, bottom navigation 56,
/// `kPageDefaultVerticalPadding` 24).
library;

/// The content area at the supported floor client height of 620.
const double floorContent = 506;

/// The content area at the design client height of 840.
const double designContent = 726;
