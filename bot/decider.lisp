
; Initializer
(def main (world something)
     (CONS 0 step))

(def step (aistate world)
     (CONS 0 (onestep world)))

; Keep moving forward
; When we have a choice, choose wisely
(def onestep (world)
     (if (CEQ (choice_count world) 0)
       (lm_backward_dir world)
       (if (CEQ (choice_count world) 1)
         (only_choice world)
         (best_choice world))))

(def only_choice (world)
     (CAR (choices world)))

; Unwrap the min choice, and from that unwrap the actual choice (direction)
(def best_choice (world)
     (CDR (CDR (min_choice_dist (choices_dist world (first_pill_xy world))))))

; Turn choices (directions) into a list of [ (x,y), direction ]
(def choices_loc (world)
     (map2 (choices world) choice_loc world))

(def choice_loc (world choice)
     (get_dir_loc (world_map world) (lm_x world) (lm_y world) choice))

; Find the distance between each available choice and our goal
(def choices_dist (world destination)
     (loc_list_xy_dist manhattan_dist (choices_loc world) destination))

(def min_choice_dist (choice_dists)
     (min_choice_dist_rec choice_dists (CONS 999999999 0)))

(def min_choice_dist_rec (choice_dists best)
     (tif (ATOM choice_dists)
       (return best)
       (tif (CGT (CAR (CAR choice_dists)) (CAR best))
         (tailcall min_choice_dist_rec (CDR choice_dists) best)
         (tailcall min_choice_dist_rec (CDR choice_dists) (CAR choice_dists)))))


; awwaiid: I don't like this maybe_ blah blah
(def choices (world)
     (maybe_left world (maybe_forward world (maybe_right world 0))))

(def maybe_left (world others)
     (if (is_option world (lm_left_dir world))
       (CONS (lm_left_dir world) others)
       others))

(def maybe_forward (world others)
     (if (is_option world (lm_forward_dir world))
       (CONS (lm_forward_dir world) others)
       others))

(def maybe_right (world others)
     (if (is_option world (lm_right_dir world))
       (CONS (lm_right_dir world) others)
       others))

(def maybe_backward (world others)
     (if (is_option world (lm_backward_dir world))
       (CONS (lm_backward_dir world) others)
       others))

(def choice_count (world)
     (length (choices world)))

(def is_option (world dir)
     (not (CEQ (get_lm_in_dir world dir) (wall))))

; Pill Finder
; -----------

(def first_pill_xy (world)
     (CAR (first_pill (world_map world))))

(def first_pill (worldmap)
     (CAR (pill_locs worldmap)))

(def pill_locs (worldmap)
  (filter (to_loc_list worldmap) is_pill))

(def is_pill (map_location)
     (CEQ (loc_content map_location) (power_pill)))


; Functions to work with relative direction
; -----------------------------------------

(def lm_left_dir (world)
     (dec_dir (lm_direction world)))

(def lm_right_dir (world)
     (inc_dir (lm_direction world)))

(def lm_forward_dir (world)
     (lm_direction world))

(def lm_backward_dir (world)
     (inc_dir (inc_dir (lm_direction world))))

(def get_lm_forward (world)
     (get_lm_in_dir world (lm_direction world)))

(def get_lm_in_dir (world dir)
     (get_in_dir
        (world_map world) (lm_x world) (lm_y world) dir))

(def lm_dir_xy (world dir)
     (get_in_dir
        (world_map world) (lm_x world) (lm_y world) dir))

; Delicious Libraries
; -------------------

INCLUDE "bot/lib/lang.lisp"
INCLUDE "bot/lib/map.lisp"
INCLUDE "bot/lib/dir.lisp"
INCLUDE "bot/lib/world.lisp"

