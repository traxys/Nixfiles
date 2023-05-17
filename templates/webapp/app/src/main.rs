use log::Level;
use yew::prelude::*;
use yew_router::prelude::*;

#[derive(Routable, Debug, Clone, Copy, PartialEq, Eq)]
enum Route {
    #[at("/")]
    Index,
    #[at("/404")]
    #[not_found]
    NotFound,
}

#[function_component]
fn App() -> Html {
    html! {
        <BrowserRouter>
            <main>
                <Switch<Route> render={switch} />
            </main>
        </BrowserRouter>
    }
}

fn switch(route: Route) -> Html {
    match route {
        Route::Index => html! {
            "Index"
        },
        Route::NotFound => html! {
            "Page not found"
        },
    }
}

fn main() {
    console_log::init_with_level(Level::Debug).unwrap();

    yew::Renderer::<App>::new().render();
}
