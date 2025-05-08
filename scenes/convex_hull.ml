open Graphics;;
open Algorithms;;

module Conf = struct
  let title = "Convex hull"
  let res = Graphics_utils.default_res
  let background_color = 0x1e1b25
  let primary_color = 0xc0b0da
  let secondary_color = 0x745d95
end;;

module Scene = Scene.Make(Conf);;

let draw_scene points =
  Scene.clean ();
  
  set_color Conf.secondary_color;
  if points <> [||] then
    points
    |> Convex_hull.compute
    |> Array.map Scene.screen_coords
    |> draw_poly;

  set_color Conf.primary_color;
  points |> Array.iter (fun p ->
    let (x, y) = Scene.screen_coords p in
    fill_circle x y (Scene.point_size ())
  );

  synchronize ()
;;

let points = ref [];;

Scene.event_loop (fun () ->
  draw_scene @@ Array.of_list !points;
  let status = wait_next_event [Button_down] in
  let mouse_pos = Scene.world_coords (status.mouse_x, status.mouse_y) in
  points := mouse_pos :: !points;
);;
