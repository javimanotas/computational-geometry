(*

This implementation uses a simplified version of the sweep line algorithm,
designed to avoid floating-point precision errors.

At initialization, each segment is normalized so that its upper endpoint comes
first, ensuring consistent processing.

An imaginary horizontal sweep line then moves downward across the plane.
Whenever a new segment begins to intersect the sweep line, it checks for
intersections with all other segments currently intersecting the line.

*)

type segment = float * float * float * float

let compute segments =
  let intersection_point (x1, y1, x2, y2) (x3, y3, x4, y4) =
    let denom = (x4 -. x3) *. (y2 -. y1) -. (y4 -. y3) *. (x2 -. x1) in
    if abs_float denom <= 1e-6 then
      None
    else
      let alpha = ((x4 -. x3) *. (y3 -. y1) -. (y4 -. y3) *. (x3 -. x1)) /. denom
      and beta = ((x2 -. x1) *. (y3 -. y1) -. (y2 -. y1) *. (x3 -. x1)) /. denom in
      if alpha < 0. || alpha > 1. || beta < 0. || beta > 1. then
        None
      else
        Some (x1 +. alpha *. (x2 -. x1), y1 +. alpha *. (y2 -. y1)) in

  let cmp_point (a, b) (c, d) = compare (-.b, a) (-.d, c) in

  let module EventQueue = Set.Make(struct
    type t = (float * float) * segment list * segment list
    let compare (a, _, _) (b, _, _) = cmp_point a b
  end) in

  let module Status = Set.Make(struct
    type t = segment
    let compare = compare
  end) in

  let queue = ref EventQueue.empty in
  let status = ref Status.empty in

  segments |> Array.iter (fun (a, b, c, d) ->
    let ((a, b, c, d) as s) =
      if cmp_point (a, b) (c, d) < 0 then
        (a, b, c, d)
      else
        (c, d, a, b) in
    let (top, bot) = match EventQueue.find_opt ((a, b), [], []) !queue with
      | None -> ([], [])
      | Some (_, t, b) -> (t, b) in
    queue := EventQueue.remove ((a, b), [], []) !queue;
    queue := EventQueue.add ((a, b), s::top, bot) !queue;
    let (top, bot) = match EventQueue.find_opt ((c, d), [], []) !queue with
      | None -> ([], [])
      | Some (_, t, b) -> (t, b) in
    queue := EventQueue.remove ((c, d), [], []) !queue;
    queue := EventQueue.add ((c, d), top, s::bot) !queue;
  );

  let intersections = ref [] in
  
  while not (EventQueue.is_empty !queue) do
    let (p, top, bot) as min = EventQueue.min_elt !queue in
    queue := EventQueue.remove min !queue;

    if List.compare_length_with top 1 > 0 then
      intersections := p :: !intersections;
    
    top |> List.iter (fun seg ->
    Status.elements !status |> List.iter (fun seg2 ->
      match intersection_point seg seg2 with
        | None -> ()
        | Some p -> intersections := p :: !intersections
    ));
    status := List.fold_left (fun s x -> Status.add x s) !status top;
    status := List.fold_left (fun s x -> Status.remove x s) !status bot
  done;

  !intersections |> Array.of_list
;;
