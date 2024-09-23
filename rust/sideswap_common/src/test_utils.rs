use rand::SeedableRng;

pub fn test_rng_from_seed(seed: u64) -> impl rand::Rng {
    rand::rngs::StdRng::seed_from_u64(seed)
}

pub fn test_rng() -> impl rand::Rng {
    let seed: u64 = rand::random();
    println!("seed: {seed}");
    test_rng_from_seed(seed)
}
