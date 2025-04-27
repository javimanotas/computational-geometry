open Graphics;;

let default_res = (1280, 720);;

let open_window (width, height) background_color title =
  open_graph @@ Printf.sprintf " %dx%d" width height;
  set_window_title title;
  set_color background_color;
  fill_rect 0 0 width height;
  auto_synchronize false
;;

let wait_till_window_closed () =
  try
    while true do
      read_key () |> ignore
    done
  with
    Graphic_failure _ -> ()
;;

let change_range size f =
  (f +. 1.) /. 2. *. float_of_int size |> int_of_float
;;

let screen_of_world_coords (_, height) (x, y) =
  let new_x = change_range height x
  and new_y = change_range height y in
  (new_x, new_y)
;;
