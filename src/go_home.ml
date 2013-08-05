let relative_db_dir = ".config/go-home"
let db_filename = "go-home.db"

let ensure_dir_exists dir =
  if Sys.file_exists dir then begin
    if not (Sys.is_directory dir)
    then failwith (Printf.sprintf "%s exists but is not a directory" dir)
  end
  else Unix.mkdir dir 0o755

module Db = struct
  exception Bad_return_code of Sqlite3.Rc.t

  let expect_ok = function
    | Sqlite3.Rc.OK -> ()
    | x -> raise (Bad_return_code x)

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
end

let () =
  let home_dir =
    try Sys.getenv "HOME"
    with Not_found -> failwith "Couldn't read home directory"
  in
  (* Make sure there's a directory for the database. *)
  let db_dir = Filename.concat home_dir relative_db_dir in
  ensure_dir_exists db_dir;
  let db_path = Filename.concat db_dir db_filename in
  Db.with_db db_path (fun db -> ())
