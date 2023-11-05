use std::{net::SocketAddr, sync::Arc};

use axum::{
    http::StatusCode,
    response::{Html, IntoResponse},
    routing::get,
    Router,
};
use serde::{Deserialize, Serialize};
use tera::{Context, Tera};
use tower_http::trace::TraceLayer;
use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt};

#[derive(thiserror::Error, Debug)]
enum Error {
    #[error("Could not render tera template")]
    Template(#[from] tera::Error),
}

impl IntoResponse for Error {
    fn into_response(self) -> axum::response::Response {
        tracing::error!("Failure in route: {self:?}");

        match self {
            Error::Template(_) => (
                StatusCode::INTERNAL_SERVER_ERROR,
                "an internal error occured",
            )
                .into_response(),
        }
    }
}

const TEMPLATE_DIR: &str = match option_env!("TEMPLATE_DIR") {
    Some(s) => s,
    None => "templates",
};

struct AppState {
    templates: Tera,
}

type State = axum::extract::State<Arc<AppState>>;

async fn index(state: State) -> Result<Html<String>, Error> {
    let rendered = state.templates.render("index.html", &Context::new())?;

    Ok(rendered.into())
}

fn mk_port() -> u16 {
    8080
}

#[derive(Serialize, Deserialize)]
struct Config {
    #[serde(default = "mk_port")]
    port: u16,
}

#[tokio::main(flavor = "current_thread")]
async fn main() {
    tracing_subscriber::registry()
        .with(tracing_subscriber::EnvFilter::from_default_env())
        .with(tracing_subscriber::fmt::layer())
        .init();

    let config: Config = envious::Config::default()
        .build_from_env()
        .expect("could not get env vars");

    let templates = Tera::new(&format!("{TEMPLATE_DIR}/**/*.html")).unwrap();
    let state = Arc::new(AppState { templates });

    let router = Router::new()
        .route("/", get(index))
        .with_state(state)
        .layer(TraceLayer::new_for_http());

    tracing::info!("Listening on port {}", config.port);

    let listen = SocketAddr::new("0.0.0.0".parse().unwrap(), config.port);
    axum::Server::bind(&listen)
        .serve(router.into_make_service())
        .await
        .expect("web server failed");
}

