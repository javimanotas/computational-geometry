type 'a t = { mutable content : 'a option array
            ; mutable size : int
            }

let empty () = {
  content = [||];
  size = 0;
};;

let to_array arr_list =
  let content = Array.sub arr_list.content 0 arr_list.size in
  Array.sub (Array.map Option.get content) 0 arr_list.size
;;

let of_array arr =
  let len = Array.length arr in
  let content = Array.init len (fun i -> Some arr.(i)) in
  { content; size = len }
;;

let length arr_list =
  arr_list.size
;;

let get arr_list i =
  if i < 0 || i >= arr_list.size then
    raise (Invalid_argument "Array_list.get: index out of bounds");
  Option.get arr_list.content.(i)
;;

let resize_if_full arr_list =
  if arr_list.size = Array.length arr_list.content then begin
    let new_capacity = min (max 1 (2 * arr_list.size)) Sys.max_array_length in
    let new_content = Array.make new_capacity None in
    Array.blit arr_list.content 0 new_content 0 arr_list.size;
    arr_list.content <- new_content
  end
;;

let add arr_list x =
  resize_if_full arr_list;
  arr_list.content.(arr_list.size) <- Some x;
  arr_list.size <- arr_list.size + 1
;;

let remove_at arr_list i : unit =
  if i < 0 || i >= arr_list.size then
    raise (Invalid_argument "Array_list.remove_at: index out of bounds");
  for j = i to arr_list.size - 2 do
    arr_list.content.(j) <- arr_list.content.(j + 1)
  done;
  arr_list.size <- arr_list.size - 1
;;

let remove_last arr_list =
  if arr_list.size = 0 then
    raise (Invalid_argument "Array_list.remove_last: empty");
  arr_list.size <- arr_list.size - 1
;;
