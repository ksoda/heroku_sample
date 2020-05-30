use std::ops::Deref;

use diesel::pg::PgConnection;
use diesel::r2d2::{ConnectionManager, Pool, PoolError, PooledConnection};

use crate::model::{NewTask, Task};

pub type PgPool = Pool<ConnectionManager<PgConnection>>;
type PgPooledConnection = PooledConnection<ConnectionManager<PgConnection>>;

pub fn init_pool(database_url: &str) -> Result<PgPool, PoolError> {
    let manager = ConnectionManager::<PgConnection>::new(database_url);
    Pool::builder().build(manager)
}

fn get_conn(pool: &PgPool) -> Result<PgPooledConnection, &'static str> {
    pool.get().map_err(|_| "Can't get connection")
}

pub fn get_all_tasks(pool: &PgPool) -> Result<Vec<Task>, &'static str> {
    Task::all(get_conn(pool)?.deref()).map_err(|_| "Error getting tasks")
}

pub fn create_task(todo: NewTask, pool: &PgPool) -> Result<Task, &'static str> {
    Task::insert(todo, get_conn(pool)?.deref()).map_err(|_| "Error inserting task")
}

pub fn toggle_task(id: i32, pool: &PgPool) -> Result<(), &'static str> {
    Task::toggle_with_id(id, get_conn(pool)?.deref())
        .map(|_| ())
        .map_err(|_| "Error toggling task")
}
