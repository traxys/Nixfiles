use iced::{widget::column, Sandbox, Settings};

#[derive(Clone, Copy, Debug)]
enum Message {}

struct App {}

impl Sandbox for App {
    type Message = Message;

    fn new() -> Self {
        Self {}
    }

    fn title(&self) -> String {
        "TODO change name".into()
    }

    fn update(&mut self, message: Self::Message) {
        match message {}
    }

    fn view(&self) -> iced::Element<'_, Self::Message> {
        column![].into()
    }
}

fn main() -> iced::Result {
    App::run(Settings::default())
}

