use std::{net::SocketAddr, path::PathBuf, sync::Arc};

use axum::Router;
use base64::{engine::general_purpose, Engine};
use config::{Config, ConfigError};
use jwt_simple::prelude::HS256Key;
use serde::{Deserialize, Deserializer, Serialize, Serializer};
use tower_http::services::ServeDir;

mod routes;

#[derive(Clone)]
pub(crate) struct Base64(pub(crate) HS256Key);

impl std::fmt::Debug for Base64 {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            r#"b64"{}""#,
            &general_purpose::STANDARD_NO_PAD.encode(self.0.to_bytes())
        )
    }
}

impl Serialize for Base64 {
    fn serialize<S>(&self, ser: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        ser.serialize_str(&general_purpose::STANDARD_NO_PAD.encode(self.0.to_bytes()))
    }
}

impl<'de> Deserialize<'de> for Base64 {
    fn deserialize<D>(de: D) -> Result<Self, D::Error>
    where
        D: Deserializer<'de>,
    {
        use serde::de::Visitor;

        struct DecodingVisitor;
        impl<'de> Visitor<'de> for DecodingVisitor {
            type Value = Base64;

            fn expecting(&self, formatter: &mut std::fmt::Formatter) -> std::fmt::Result {
                formatter.write_str("must be a base 64 string")
            }

            fn visit_str<E>(self, v: &str) -> Result<Self::Value, E>
            where
                E: serde::de::Error,
            {
                general_purpose::STANDARD_NO_PAD
                    .decode(v)
                    .map_err(E::custom)
                    .map(|b| HS256Key::from_bytes(&b))
                    .map(Base64)
            }
        }

        de.deserialize_str(DecodingVisitor)
    }
}

#[derive(Deserialize, Debug)]
struct Settings {
    jwt_secret: Base64,
    host: String,
    port: u16,
    api_allowed: Option<String>,
    serve_app: Option<PathBuf>,
}

impl Settings {
    pub fn new() -> Result<Self, ConfigError> {
        let cfg = Config::builder()
            .add_source(config::Environment::with_prefix("WEBAPP"))
            .set_default("host", "127.0.0.1")?
            .set_default("port", "8085")?
            .set_default("api_allowed", None::<String>)?
            .set_default("serve_app", None::<String>)?
            .build()?;

        cfg.try_deserialize()
    }
}

struct AppState {
    jwt_secret: Base64,
}

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    tracing_subscriber::fmt()
        .with_max_level(tracing::Level::DEBUG)
        .with_test_writer()
        .init();

    let config = Settings::new()?;

    tracing::info!("Settings: {config:?}");

    let addr: SocketAddr = format!("{}:{}", config.host, config.port).parse()?;

    let state = Arc::new(AppState {
        jwt_secret: config.jwt_secret,
    });

    let router = Router::new()
        .nest(
            "/api",
            routes::router(config.api_allowed.map(|s| s.parse()).transpose()?),
        )
        .with_state(state);

    let router = match config.serve_app {
        None => router,
        Some(path) => router.fallback_service(ServeDir::new(path)),
    };

    Ok(axum::Server::bind(&addr)
        .serve(router.into_make_service())
        .await?)
}
