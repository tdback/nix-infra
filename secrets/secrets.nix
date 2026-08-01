let
  tdback = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKdwaIxcE1GIOUcmhU3JvnkctElHET+vZYUFhlAGOGOS tdback@trout"
  ];

  carp = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKyw9mFitoT247BSnuV6I7UPu43CnLt1XNXr/a0xkYfH carp.local";
  salmon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDt7bw02qWZkLix87a7xdVvAcmBsObPrMwS1kyo9as6O salmon.local";
  sunfish = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGCrdSs5DyKaqA2kAOi+4e0BLRVgLZBph0JtLCRGT5pe sunfish.local";

  servers = [
    carp
    salmon
    sunfish
  ];
in
{
  # Hashed user password.
  "hashed-password.age".publicKeys = tdback;

  # Matrix registration token.
  "matrix-registration-token.age".publicKeys = [ salmon ];
}
