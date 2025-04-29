open Data_structures.Array_list;;

let compute segments =
  let intersection_point (x1, y1, x2, y2) (x3, y3, x4, y4) =
    let denom = (x4 -. x3) *. (y2 -. y1) -. (y4 -. y3) *. (x2 -. x1) in
    if abs_float denom <= 0.001 then
      None
    else
      let alpha = ((x4 -. x3) *. (y3 -. y1) -. (y4 -. y3) *. (x3 -. x1)) /. denom
      and beta = ((x2 -. x1) *. (y3 -. y1) -. (y2 -. y1) *. (x3 -. x1)) /. denom in
    if alpha < 0. || alpha > 1. || beta < 0. || beta > 1. then
      None
    else
      Some (x1 +. alpha *. (x2 -. x1), y1 +. alpha *. (y2 -. y1)) in
  
  let intersections = empty () in

  segments |> Array.iteri (fun i pq ->
    segments |> Array.iteri (fun j rs ->
      if i <> j then
        match intersection_point pq rs with
          | None -> ()
          | Some x -> add intersections x
      else
        ()
  ));
    
  to_array intersections
;;
