let p1 = [%here]
let p2 = [%here]
let equal_position (a : Lexing.position) (b : Lexing.position) = Stdlib.compare a b = 0

let%expect_test "equal" =
  let r1 = Loc.create (p1, p2) in
  require [%here] (equal_position (Loc.start r1) p1);
  [%expect {||}];
  require [%here] (equal_position (Loc.stop r1) p2);
  [%expect {||}];
  require [%here] (not (equal_position (Loc.start r1) p2));
  [%expect {||}];
  require [%here] (not (equal_position (Loc.stop r1) p1));
  [%expect {||}];
  ()
;;
