let read_file file_path =
  let channel = open_in file_path
  and lines = ref [] in
  try
    while true do
      lines := input_line channel :: !lines
    done;
    raise (Failure "this part of the code is unreachable")
  with
    End_of_file ->
      List.rev !lines
;;
