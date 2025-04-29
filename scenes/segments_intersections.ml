open Graphics;;
open Data_structures;;
open Algorithms;;

module Conf = struct
  let title = "Segments intersections"
  let res = Graphics_utils.default_res
  let background_color = 0x1c2326
  let primary_color = 0xb0cbd9
  let secondary_color = 0x5c8194
end;;

let cross_color = 0xf7605c;;

module Scene = Scene.Make(Conf);;

let draw_scene segments =
  let screen_segments =
    segments |> Array.map (fun (a, b, c, d) -> 
      let (a, b) = Scene.screen_coords (a, b)
      and (c, d) = Scene.screen_coords (c, d) in
      (a, b, c, d)
    ) in
  
  Scene.clean ();

  set_color Conf.secondary_color;
  draw_segments screen_segments;
  
  set_color Conf.primary_color;
  let (starts, ends) =
    screen_segments
    |> Array.map (fun (a, b, c, d) -> (a, b), (c, d))
    |> Array.split in
  Array.append starts ends
  |> Array.iter (fun (x, y) ->
    fill_circle x y (Scene.point_size ())
  );
  
  set_color cross_color;
  let draw_cross x y =
    let size = Scene.point_size () in
    draw_segments [| (x - size, y - size, x + size, y + size)
                   ; (x + size, y - size, x - size, y + size) |] in
  segments
  |> Segments_intersections.compute
  |> Array.map Scene.screen_coords
  |> Array.iter (fun (x, y) -> draw_cross x y);

  synchronize ()
;;

Scene.init ();;

draw_scene [||];;

let segments = Array_list.empty ();;

Scene.event_loop (fun () ->
  let status = wait_next_event [Button_down] in
  let (px, py) = Scene.world_coords (status.mouse_x, status.mouse_y) in
  let has_released = ref false in
  while not !has_released do
    let status = wait_next_event [Button_up; Mouse_motion] in
    let (qx, qy) = Scene.world_coords (status.mouse_x, status.mouse_y) in
    let segment = (px, py, qx, qy) in
    if status.button then
      draw_scene (Array.append [|segment|] @@ Array_list.to_array segments )
    else begin
      Array_list.add segments segment;
      draw_scene @@ Array_list.to_array segments;
      has_released := true
    end
  done
);;
