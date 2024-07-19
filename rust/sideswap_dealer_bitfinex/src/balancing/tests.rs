use super::*;

#[test]
fn test_balancing() {
    // Bitcoin is smaller
    assert_eq!(
        get_balancing(0.5, 0.5, 27500.0, 27500.0, 50000.0),
        AssetBalancing::None
    );
    assert_eq!(
        get_balancing(0.2, 0.8, 27500.0, 27500.0, 50000.0),
        AssetBalancing::RecvBtc(0.3)
    );
    assert_eq!(
        get_balancing(0.8, 0.2, 27500.0, 27500.0, 50000.0),
        AssetBalancing::SendBtc(0.3)
    );
    assert_eq!(
        get_balancing(0.3, 0.7, 10000.0, 45000.0, 50000.0),
        AssetBalancing::RecvUsdt(25000.0)
    );
    assert_eq!(
        get_balancing(0.7, 0.3, 10000.0, 45000.0, 50000.0),
        AssetBalancing::RecvUsdt(5000.0)
    );
    assert_eq!(
        get_balancing(0.3, 0.7, 34500.0, 15500.0, 50000.0),
        AssetBalancing::None
    );
    assert_eq!(
        get_balancing(0.7, 0.3, 15000.0, 35000.0, 50000.0),
        AssetBalancing::None
    );

    // USDt is smaller
    assert_eq!(
        get_balancing(0.5, 0.5, 22500.0, 22500.0, 50000.0),
        AssetBalancing::None
    );
    assert_eq!(
        get_balancing(0.5, 0.5, 5000.0, 40000.0, 50000.0),
        AssetBalancing::RecvUsdt(17500.0)
    );
    assert_eq!(
        get_balancing(0.5, 0.5, 40000.0, 5000.0, 50000.0),
        AssetBalancing::SendUsdt(17500.0)
    );
    assert_eq!(
        get_balancing(0.2, 0.8, 13500.0, 31500.0, 50000.0),
        AssetBalancing::RecvBtc(0.43)
    );
    assert_eq!(
        get_balancing(0.8, 0.2, 13500.0, 31500.0, 50000.0),
        AssetBalancing::SendBtc(0.07)
    );
    assert_eq!(
        get_balancing(0.7, 0.3, 13500.0, 31500.0, 50000.0),
        AssetBalancing::None
    );
    assert_eq!(
        get_balancing(0.3, 0.7, 31500.0, 13500.0, 50000.0),
        AssetBalancing::None
    );
}
