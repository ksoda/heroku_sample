use actix_files::NamedFile;
use actix_web::middleware::errhandlers::ErrorHandlerResponse;
use actix_web::{dev, web, Error, HttpResponse, Result};

use crate::model::NewTask;

use crate::db;

pub async fn index(pool: web::Data<db::PgPool>) -> Result<HttpResponse, Error> {
    let tasks = web::block(move || db::get_all_tasks(&pool)).await?;
    let j = serde_json::to_string(&tasks)?;
    Ok(HttpResponse::Ok().body(j))
}

pub async fn create(
    pool: web::Data<db::PgPool>,
    item: web::Json<NewTask>,
) -> Result<HttpResponse, Error> {
    let task = web::block(move || db::create_task(item.into_inner(), &pool)).await?;
    let j = serde_json::to_string(&task)?;
    println!("{:?}", j);
    Ok(HttpResponse::Created().body(j))
}

pub async fn update(db: web::Data<db::PgPool>) -> Result<HttpResponse, Error> {
    web::block(move || db::toggle_task(1, &db)).await?;
    Ok(HttpResponse::Ok().body(""))
}

pub fn internal_server_error<B>(res: dev::ServiceResponse<B>) -> Result<ErrorHandlerResponse<B>> {
    let new_resp = NamedFile::open("static/errors/500.html")?
        .set_status_code(res.status())
        .into_response(res.request())?;
    Ok(ErrorHandlerResponse::Response(
        res.into_response(new_resp.into_body()),
    ))
}
