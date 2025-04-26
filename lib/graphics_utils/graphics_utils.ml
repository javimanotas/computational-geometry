open Graphics;;

let open_window (width, height) background_color =
  open_graph @@ Printf.sprintf " %dx%d" width height;
  set_window_title "Computational geometry";
  set_color background_color;
  fill_rect 0 0 width height
;;

let wait_till_window_closed () =
  try
    while true do
      read_key () |> ignore
    done
  with
    Graphic_failure _ -> ()
;;
