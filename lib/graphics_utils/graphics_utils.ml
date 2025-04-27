open Graphics;;

let default_res = (1280, 720);;

let open_window (width, height) background_color title =
  open_graph @@ Printf.sprintf " %dx%d" width height;
  set_window_title title;
  set_color background_color;
  fill_rect 0 0 width height;
  auto_synchronize false
;;
