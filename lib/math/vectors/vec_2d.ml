type vector = float * float

let add (ux, uy) (vx, vy) =
  (ux +. vx, uy +. vy)
;;

let (@+) = add;;

let subtract (ux, uy) (vx, vy) = 
  (ux -. vx, uy -. vy)
;;

let (@-) = subtract;;

let dot (ux, uy) (vx, vy) =
  ux *. vx +. uy *. vy
;;

let (@*) = dot;;

let times k (x, y) =
  (k *. x, k *. y)
;;

let ( *@) = times;;
