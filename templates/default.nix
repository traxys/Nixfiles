{
  flake.templates = {
    rust = {
      path = ./rust;
      description = "My rust template using rust-overlay and direnv";
    };
    perseus = {
      path = ./perseus;
      description = "A perseus frontend with rust-overlay & direnv";
    };
    webapp = {
      path = ./webapp;
      description = "A template for a web application (frontend + backend)";
    };
    webserver = {
      path = ./webserver;
      description = "A template for a web server (using templates for the frontend)";
    };
    gui = {
      path = ./gui;
      description = "A template for rust GUI applications";
    };
  };
}
