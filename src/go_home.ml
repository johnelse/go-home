let relative_db_dir = ".config/go-home"
let db_filename = "go-home.db"

let ensure_dir_exists dir =
  if Sys.file_exists dir then begin
    if not (Sys.is_directory dir)
    then failwith (Printf.sprintf "%s exists but is not a directory" dir)
  end
  else Unix.mkdir dir 0o755

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
