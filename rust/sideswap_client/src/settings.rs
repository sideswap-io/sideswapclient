use super::ffi::ffi::StartParams;
use clap::Clap;

#[derive(Clap, Debug)]
#[clap(name = "SideSwap")]
struct Opt {
    #[clap(long)]
    rpc_host: Option<String>,

    #[clap(long)]
    rpc_port: Option<u16>,

    #[clap(long)]
    rpc_login: Option<String>,

    #[clap(long)]
    rpc_password: Option<String>,

    #[clap(long)]
    db_path: Option<String>,

    #[clap(long)]
    as_dealer: Option<bool>,
}

pub fn parse_args(mut params: StartParams) -> StartParams {
    let opt = Opt::parse();

    if let Some(v) = opt.rpc_host {
        params.elements.host = v.to_owned();
    }
    if let Some(v) = opt.rpc_port {
        params.elements.port = v;
    }
    if let Some(v) = opt.rpc_login {
        params.elements.login = v.to_owned();
    }
    if let Some(v) = opt.rpc_password {
        params.elements.password = v.to_owned();
    }
    if let Some(v) = opt.db_path {
        params.db_path = v.to_owned();
    }
    if let Some(v) = opt.as_dealer {
        params.is_dealer = v.to_owned();
    }

    params
}
