open Data_structures.Array_list;;

(*

This implementation uses an incremental approach.

The first step is to sort the points by their x-coordinate, ensuring they are
processed in left-to-right order.

To construct the upper hull, we begin with the first two sorted points and then
iterate through the remaining points one by one. For each new point added, we
check whether the last three points in the current hull form a right turn. If
not, the middle point is removed (as it would create a concave angle), and this
check continues until the last three points do form a right turn.

Once the upper hull is built, we repeat the process by looping in reverse order
to compute the lower hull.

Finally, the convex hull is obtained by combining the upper and lower parts
(excluding the duplicate endpoints where they meet).

*)

let compute points =
  let is_right_turn (px, py) (qx, qy) (rx, ry) =
    (qx -. px) *. (ry -. qy) -. (qy -. py) *. (rx -. qx) < 0. in

  Array.sort compare points;
  let n = Array.length points in
  let upper = of_array [|points.(0); points.(1)|]
  and lower = of_array [|points.(n - 1); points.(n - 2)|] in

  for i = 2 to n - 1 do
    add upper points.(i);
    while
      let len = length upper in
      len > 2 &&
      let x = get upper (len - 3)
      and y = get upper (len - 2)
      and z = get upper (len - 1)
      in not (is_right_turn x y z) do
        remove_at upper (length upper - 2)
    done
  done;

  for i = n - 3 downto 0 do
    add lower points.(i);
    while
      let len = length lower in
      len > 2 &&
      let x = get lower (len - 3)
      and y = get lower (len - 2)
      and z = get lower (len - 1)
      in not (is_right_turn x y z) do
        remove_at lower (length lower - 2)
    done
  done;

  remove_last upper;
  remove_last lower;
  Array.append (to_array upper) (to_array lower)
;;
