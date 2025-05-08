(*

This implementation follows an incremental approach.

First, the input points are sorted by their x-coordinate to ensure they are
processed from left to right.

To build the upper hull, points are added one by one to a working list. After
each addition, the last three points are checked to see if they form a right
turn. If they don’t (i.e., they form a concave angle), the middle point is
removed. This check continues recursively until the right-turn condition is
restored.

Once the upper hull is complete, the same process is repeated in reverse order
to construct the lower hull.

The final convex hull is obtained by concatenating the upper and lower hulls,
omitting the duplicate endpoints where they meet.

Note: the input should be a non empty array.

*)

let compute points =
  let is_right_turn (px, py) (qx, qy) (rx, ry) =
    (qx -. px) *. (ry -. qy) -. (qy -. py) *. (rx -. qx) < 0. in

  let rec rm_left_turns = function
    | (a::b::c::l) when not (is_right_turn c b a) -> rm_left_turns (a::c::l)
    | other -> other in

  Array.sort compare points;

  let upper_hull = Array.fold_right (fun p l -> rm_left_turns (p::l)) points []
  and lower_hull = Array.fold_left (fun l p -> rm_left_turns (p::l)) [] points in
  Array.of_list (List.tl upper_hull @ List.tl lower_hull)
;;
