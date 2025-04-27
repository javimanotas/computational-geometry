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
  ;;
  
  let clean () =
    Graphics.set_color Conf.background_color;
    Graphics.fill_rect 0 0 (Graphics.size_x ()) (Graphics.size_y ());
  ;;

  let convert_coords =
    Graphics_utils.screen_of_world_coords Conf.res
  ;;

  let point_size = snd Conf.res / 100;;
end
