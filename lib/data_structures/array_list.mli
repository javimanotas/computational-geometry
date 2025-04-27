type 'a t

val empty : unit -> 'a t

val to_array : 'a t -> 'a array

val of_array : 'a array -> 'a t

val length : 'a t -> int

val get : 'a t -> int -> 'a

val add : 'a t -> 'a -> unit

val remove_at : 'a t -> int -> unit

val remove_last : 'a t -> unit
