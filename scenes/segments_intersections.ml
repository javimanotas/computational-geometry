open Graphics;;
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
  Scene.clean ();

  let screen_segments =
    segments |> Array.map (fun (a, b, c, d) -> 
      let (a, b) = Scene.screen_coords (a, b)
      and (c, d) = Scene.screen_coords (c, d) in
      (a, b, c, d)
    ) in

  set_color Conf.secondary_color;
  draw_segments screen_segments;

  set_color Conf.primary_color;
  screen_segments
  |> Array.map (fun (a, b, c, d) -> (a, b), (c, d))
  |> Array.split
  |> fun (a, b) -> Array.append a b
  |> Array.iter (fun (x, y) ->
    fill_circle x y (Scene.point_size ())
  );
  
  set_color cross_color;
  segments
  |> Segments_intersections.compute
  |> Array.map Scene.screen_coords
  |> Array.iter (fun (x, y) ->
    let size = Scene.point_size () in
    draw_segments [|
      (x - size, y - size, x + size, y + size);
      (x + size, y - size, x - size, y + size)|]
  );

  synchronize ()
;;

let segments = ref [];;
let mouse_click = ref None;;

Scene.event_loop (fun () ->
  draw_scene @@ Array.of_list !segments;

  match !mouse_click with
    | None ->
      let status = wait_next_event [Button_down] in
      let (px, py) = Scene.world_coords (status.mouse_x, status.mouse_y) in
      segments := (px, py, px, py) :: !segments;
      mouse_click := Some (px, py)
    | Some (px, py) -> begin
      let status = wait_next_event [Button_up; Mouse_motion] in
      let (qx, qy) = Scene.world_coords (status.mouse_x, status.mouse_y) in
      segments := (px, py, qx, qy) :: List.tl !segments;
      if not status.button then
        mouse_click := None end
);;
