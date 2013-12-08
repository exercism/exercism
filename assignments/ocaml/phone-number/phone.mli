(** Extract the digits from a valid phone number. *)
val number : string -> string option

(** Extract the area code from a valid phone number. *)
val area_code : string -> string option

(** Pretty print a valid phone number. *)
val pretty : string -> string option
