open Data_structures;;

type segment = float * float * float * float

let epsilon = 1e-4;;

(*

This implementation uses a sweep line technique combined with an event queue to
efficiently detect all intersections between segments.

At the start, each segment is normalized so that its upper endpoint comes
first. All segment endpoints are then inserted into a priority queue (the event
queue), sorted by decreasing y-coordinate (top to bottom sweep).

As the sweep line moves downward through the plane, segments are added or
removed from an ordered status structure depending on whether their endpoints
are encountered. Whenever a segment is added or changes position, the algorithm
checks for intersections with its immediate neighbors in the structure.

If an intersection is found, the order of the two intersecting segments is
swapped, and potential new intersections with their updated neighbors are
scheduled as future events.

*)

let compute segments =
  let intersection_point (x1, y1, x2, y2) (x3, y3, x4, y4) =
    let denom = (x4 -. x3) *. (y2 -. y1) -. (y4 -. y3) *. (x2 -. x1) in
    if abs_float denom <= epsilon then
      None
    else
      let alpha = ((x4 -. x3) *. (y3 -. y1) -. (y4 -. y3) *. (x3 -. x1)) /. denom
      and beta = ((x2 -. x1) *. (y3 -. y1) -. (y2 -. y1) *. (x3 -. x1)) /. denom in
    if alpha < 0. || alpha > 1. || beta < 0. || beta > 1. then
      None
    else
      Some (x1 +. alpha *. (x2 -. x1), y1 +. alpha *. (y2 -. y1)) in

  let contains_point (px, py) (x1, y1, x2, y2) =
    let within_bounds =
      min x1 x2 <= px && px <= max x1 x2 &&
      min y1 y2 <= py && py <= max y1 y2 in
    let cross = (x2 -. x1) *. (py -. y1) -. (y2 -. y1) *. (px -. x1) in
    within_bounds && abs_float cross < epsilon in
  
  let cmp_points (px, py) (qx, qy) =
    compare (-.py, px) (-.qy, qx) in
 
  let segments =
    segments
    |> Array.map (fun ((x1, y1, x2, y2) as s) ->
      if cmp_points (x1, y1) (x2, y2) <= 0 then
        s
      else
        (x2, y2, x1, y1)
    ) in
  
  let module Q = Set.Make(struct
    type t = (float * float) * segment list * segment list
    let compare (p, _, _) (q, _, _) =
      cmp_points p q
  end) in

  let event_points = ref Q.empty in

  let get_assoc p =
    (p, [], [])
    |> Fun.flip Q.find_opt !event_points
    |> Option.map (fun (_, t, b) -> (t, b))
    |> Option.value ~default:([], []) in

  segments
  |> Array.iter (fun ((px, py, qx, qy) as seg) ->
    let (p_tops, p_bots) = get_assoc (px, py) in
    event_points := Q.remove ((px, py), [], []) !event_points;
    event_points := Q.add ((px, py), seg :: p_tops, p_bots) !event_points;
    let (q_tops, q_bots) = get_assoc (qx, qy) in
    event_points := Q.remove ((qx, qy), [], []) !event_points;
    event_points := Q.add ((qx, qy), q_tops, seg :: q_bots) !event_points;
  );

  let sweep_line = ref infinity in

  let s_compare (x1, y1, x2, y2) (x3, y3, x4, y4) =
    let float_compare a b =
      if abs_float (a -. b) < epsilon then
        0
      else if a < b then
        -1
      else
        1 in
    let change_top (px, py, qx, qy) =
      let new_y = !sweep_line -. epsilon in
      let new_x = qx +. (px -. qx) *. (new_y -. qy) /. (py -. qy) in
      (new_x, new_y, qx, qy) in
    let (x1, _, x2, _) = change_top (x1, y1, x2, y2)
    and (x3, _, x4, _) = change_top (x3, y3, x4, y4) in
    match float_compare x1 x3 with
      | 0 -> float_compare x2 x4
      | other -> other in

  let status = ref [] in
  let intersections = Array_list.empty () in

  let find_new_event sl sr (px, _) =
    match intersection_point sl sr with
      | None -> ()
      | Some (qx, qy) ->
        if qy < !sweep_line || qy = !sweep_line && qx > px then
          event_points := Q.add ((qx, qy), [], []) !event_points in

  let handle_event_point (p, uppers, lowers) =
    if List.length (List.filter (contains_point p) !status) > 1 then
      Array_list.add intersections p;
      
    status := List.filter (fun x -> not (List.mem x lowers)) !status;
    status := List.append !status uppers;
    status := List.sort s_compare !status;
    
    (* this block of code is a non rigurous fix for floating point errors.
    it adds more overhead to the calculations but ensure there are not
    intersecionts missing *)
    begin try
      List.iteri (fun i x -> find_new_event x (List.nth !status (i + 1)) p) !status
    with
      Failure _ -> () end;

    let uc = List.filter (contains_point p) !status in
    match uc with
      | [] ->
        begin try
          let sl = List.find (fun x -> intersection_point (-1000., snd p, fst p -. 0.1, snd p) x <> None) (List.rev !status)
          and sr = List.find (fun x -> intersection_point (fst p +. 0.1, snd p, 1000., snd p) x <> None) !status in
          find_new_event sl sr p
        with
          Not_found -> () end
      | uchd::uctl ->
        begin try
          let s' = List.fold_left (fun a b -> if s_compare a b <= 0 then a else b) uchd uctl in
          let sl = List.find (fun x -> s_compare x s' < 0) (List.rev !status) in
          find_new_event sl s' p;
        with
          Not_found -> ();
        try
          let s'' = List.fold_left (fun a b -> if s_compare a b <= 0 then b else a) uchd uctl in
          let sr = List.find (fun x -> s_compare x s'' > 0) !status in
          find_new_event s'' sr p
        with
          Not_found -> () end in

  while not (Q.is_empty !event_points) do
    let ((_, y), _, _) as min = Q.min_elt !event_points in
    event_points := Q.remove min !event_points;
    sweep_line := y;
    handle_event_point min
  done;

  Array_list.to_array intersections
;;
