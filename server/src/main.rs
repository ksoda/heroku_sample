#[macro_use]
extern crate diesel;
#[macro_use]
extern crate log;

use std::{env, io};

use actix_cors::Cors;
use actix_files as fs;
use actix_web::middleware::{errhandlers::ErrorHandlers, Logger};
use actix_web::{http, web, App, HttpServer};
use dotenv::dotenv;

mod api;
mod db;
mod model;
mod schema;

#[actix_rt::main]
async fn main() -> io::Result<()> {
    dotenv().ok();

    env::set_var("RUST_LOG", "actix_todo=debug,actix_web=info");
    env_logger::init();

    let database_url = env::var("DATABASE_URL").expect("DATABASE_URL must be set");
    let pool = db::init_pool(&database_url).expect("Failed to create pool");
    let mut resource_sharing_url =
        env::var("RESOURCE_SHARING_URL").expect("RESOURCE_SHARING_URL must be set");
    if resource_sharing_url.ends_with('/') {
        resource_sharing_url.pop();
    }

    let app = move || {
        debug!("Constructing the App");

        let error_handlers = ErrorHandlers::new().handler(
            http::StatusCode::INTERNAL_SERVER_ERROR,
            api::internal_server_error,
        );

        App::new()
            .wrap(
                Cors::new() // <- Construct CORS middleware builder
                    .allowed_origin(&resource_sharing_url)
                    .allowed_methods(vec!["GET", "POST", "OPTION"])
                    .allowed_headers(vec![http::header::AUTHORIZATION, http::header::ACCEPT])
                    .allowed_header(http::header::CONTENT_TYPE)
                    .max_age(3600)
                    .finish(),
            )
            .data(pool.clone())
            .wrap(Logger::default())
            .wrap(error_handlers)
            .service(
                web::resource("/tasks")
                    .route(web::get().to(api::index))
                    .route(web::post().to(api::create)),
            )
            .service(web::resource("/todo/{id}").route(web::post().to(api::update)))
            .service(fs::Files::new("/static", "static/"))
    };

    let port = env::var("PORT")
        .unwrap_or_else(|_| "3000".to_string())
        .parse::<String>()
        .expect("PORT must be a number string");

    debug!("Starting server on {}", port);
    HttpServer::new(app)
        .bind(format!("0.0.0.0:{}", port))?
        .run()
        .await
}
