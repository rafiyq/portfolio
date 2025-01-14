#![allow(non_snake_case)]

#[cfg(feature = "ssr")]
use worker::*;
use crate::app::*;

pub mod app;
pub mod components;
pub mod pages;

#[cfg(feature = "ssr")]
async fn router(env: Env) -> axum::Router {
    use axum::{Extension, Router};
    use leptos::prelude::*;
    use leptos_axum::{generate_route_list, LeptosRoutes};
    use std::sync::Arc;

    let conf = get_configuration(None).unwrap();
    let leptos_options = conf.leptos_options;
    let routes = generate_route_list(App);

    Router::new()
        .leptos_routes(&leptos_options, routes, {
            let leptos_options = leptos_options.clone();
            move || shell(leptos_options.clone())
        })
        .with_state(leptos_options)
        .layer(Extension(Arc::new(env)))
}

#[cfg(feature = "ssr")]
#[event(fetch)]
async fn fetch(
    req: HttpRequest,
    env: Env,
    _ctx: Context,
) -> Result<axum::http::Response<axum::body::Body>> {
    use tower_service::Service;

    console_error_panic_hook::set_once();

    Ok(router(env).await.call(req).await?)
}

#[cfg(feature = "hydrate")]
#[wasm_bindgen::prelude::wasm_bindgen]
pub fn hydrate() {
    console_error_panic_hook::set_once();
    leptos::mount::hydrate_body(App);
}