exception Bad_return_code of Sqlite3.Rc.t

let expect_ok = function
  | Sqlite3.Rc.OK -> ()
  | code -> raise (Bad_return_code code)

let with_db db_path f =
  (* Open the database. *)
  let db_exists = Sys.file_exists db_path in
  let db = Sqlite3.db_open db_path in
  try
    if not db_exists
    then expect_ok (Sqlite3.exec db
      "create table observations (year int, month int, day int, hour int, minute int)");
    let result = f db in
    ignore (Sqlite3.db_close db);
    result
  with e ->
    ignore (Sqlite3.db_close db);
    raise e
