mod error_views;
mod templates;

use perseus::prelude::*;
use sycamore::prelude::*;

#[perseus::main(perseus_axum::dflt_server)]
fn main<G: Html>() -> PerseusApp<G> {
    PerseusApp::new()
}
