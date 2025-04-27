val default_res             : (int * int)

val open_window             : (int * int) -> Graphics.color  -> string      -> unit

val wait_till_window_closed : unit        -> unit

val screen_of_world_coords  : (int * int) -> (float * float) -> (int * int)
