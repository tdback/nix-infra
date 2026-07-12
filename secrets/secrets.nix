let
  tdback = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKdwaIxcE1GIOUcmhU3JvnkctElHET+vZYUFhlAGOGOS tdback@trout"
  ];
in
{
  # hashed user password
  "hashed-password.age".publicKeys = tdback;
}
