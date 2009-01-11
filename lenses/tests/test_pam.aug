module Test_pam =

  let example = "#%PAM-1.0
auth [user_unknown=ignore success=ok ignore=ignore default=bad] pam_securetty.so
session    optional     pam_keyinit.so force revoke
"

  test Pam.lns get example =
    { "#comment" = "%PAM-1.0" }
    { "1" { "type" = "auth" }
          { "control" = "[user_unknown=ignore success=ok ignore=ignore default=bad]" }
          { "module" = "pam_securetty.so" } }
    { "2" { "type" = "session" }
          { "control" = "optional" }
          { "module" = "pam_keyinit.so" }
          { "argument" = "force" } 
          { "argument" = "revoke" } }

  test Pam.lns put example after
    set "/1/control" "requisite"
  = "#%PAM-1.0
auth requisite pam_securetty.so
session    optional     pam_keyinit.so force revoke
"

  (* Check that trailing whitespace is handled & preserved *)
  let trailing_ws = "auth\trequired\tpam_unix.so \n"

  test Pam.lns put trailing_ws after
    set "/1/type" "auth"
  = trailing_ws

  test Pam.lns get "@include common-password\n" = 
    { "include" = "common-password" }

(* Local Variables: *)
(* mode: caml       *)
(* End:             *)
