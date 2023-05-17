use std::sync::Arc;

use api::{LoginRequest, LoginResponse};
use axum::{
    extract::State,
    http::{header::CONTENT_TYPE, HeaderValue, Method, StatusCode},
    response::IntoResponse,
    routing::post,
    Json, Router,
};
use tower_http::cors::{self, AllowOrigin, CorsLayer};

#[derive(thiserror::Error, Debug)]
enum RouteError {
    #[error("This account does not exist")]
    UnknownAccount,
}

impl IntoResponse for RouteError {
    fn into_response(self) -> axum::response::Response {
        match self {
            RouteError::UnknownAccount => {
                (StatusCode::NOT_FOUND, "Account not found").into_response()
            }
        }
    }
}

type JsonResult<T, E = RouteError> = Result<Json<T>, E>;

type AppState = Arc<crate::AppState>;

async fn login(
    State(_state): State<AppState>,
    Json(_req): Json<LoginRequest>,
) -> JsonResult<LoginResponse> {
    Err(RouteError::UnknownAccount)
}

pub(crate) fn router(api_allowed: Option<HeaderValue>) -> Router<AppState> {
    let origin: AllowOrigin = match api_allowed {
        Some(n) => n.into(),
        None => cors::Any.into(),
    };

    let cors_base = CorsLayer::new()
        .allow_headers([CONTENT_TYPE])
        .allow_origin(origin);

    let mk_service = |m: Vec<Method>| cors_base.clone().allow_methods(m);

    Router::new().route("/login", post(login).layer(mk_service(vec![Method::POST])))
}
