let relative_db_dir = ".config/go-home"
let db_filename = "go-home.db"

let ensure_dir_exists dir =
  if Sys.file_exists dir then begin
    if not (Sys.is_directory dir)
    then failwith (Printf.sprintf "%s exists but is not a directory" dir)
  end
  else Unix.mkdir dir 0o755

type action =
  | Register
  | Score

let get_action () =
  let action = ref Register in
  Arg.parse
    [(
      "-action",
      Arg.String
        (fun value ->
          action :=
            match String.lowercase value with
            | "register" -> Register
            | "score" -> Score
            | _ -> failwith "Unknown action"),
      "The action to perform - either register or score"
    )]
    (fun _ -> ())
    "Usage: go-home -action <action>";
  !action

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
