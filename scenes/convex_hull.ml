open Graphics;;
open Data_structures;;
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
  let hull =
    if Array_list.length points >= 2 then
      Convex_hull.compute @@ Array_list.to_array points
    else
      [||] in
  draw_poly @@ Array.map Scene.screen_coords hull;
  
  set_color Conf.primary_color;
  points |> Array_list.to_array |> Array.iter (fun p ->
    let (x, y) = Scene.screen_coords p in
    fill_circle x y (Scene.point_size ())
  );

  synchronize ()
;;

Scene.init ();;

let points = Array_list.empty ();;

draw_scene points;

Scene.event_loop (fun () ->
  let status = wait_next_event [Button_down] in
  let mouse_pos = Scene.world_coords (status.mouse_x, status.mouse_y) in
  Array_list.add points mouse_pos;
  draw_scene points
);;
