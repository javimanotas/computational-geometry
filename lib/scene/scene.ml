module type Config = sig
  val res : int * int
  val background_color : Graphics.color
  val primary_color : Graphics.color
  val secondary_color : Graphics.color
  val title : string
end

module Make (Conf : Config) = struct
  let init () =
    Graphics_utils.open_window Conf.res Conf.background_color Conf.title;
    Graphics.set_line_width @@ snd Conf.res / 200

  let clean () =
    Graphics.set_color Conf.background_color;
    Graphics.fill_rect 0 0 (Graphics.size_x ()) (Graphics.size_y ())

  let event_loop action =
    try
      while true do
        action ()
      done
    with
      Graphics.Graphic_failure _ ->
        ()
  
  let ratio () =
    float_of_int (Graphics.size_x ()) /. float_of_int (Graphics.size_y ())

  let screen_coords (x, y) =
    let change_range r f =
      ((f +. r) /. 2. *. float_of_int (Graphics.size_y ())) |> int_of_float in
    (change_range (ratio ()) x, change_range 1. y)

  let world_coords (x, y) =
    let change_range a b =
      2. *. float_of_int a /. b -. 1. in
    let width = float_of_int (Graphics.size_x ())
    and height = float_of_int (Graphics.size_y ()) in
    (change_range x width *. ratio (), change_range y height)

  let point_size () =
    Graphics.size_y () / 100
end
