let
  inherit
    (builtins)
    attrNames
    concatMap
    filter
    listToAttrs
    match
    readDir
    readFileType
    ;

  listFilesRecursive = base: directory:
    if readFileType directory != "directory"
    then [base]
    else let
      entries = readDir directory;
      names = attrNames entries;
    in
      concatMap (
        name:
          if entries.${name} == "directory"
          then listFilesRecursive "${base}/${name}" /${directory}/${name}
          else if entries.${name} == "regular"
          then ["${base}/${name}"]
          else []
      )
      names;

  isAge = name: match ".*\\.age$" name != null;

  hosts = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJBm+MfqJdf0kjwRzT3QPr4srZmYWl5qBbSIgPNLkkXM root@toaster"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM5al1hlsLRpQxkMaGen3IMFKHSdmW1EhiIwEU/nP0iw root@surface"
  ];
  carsons = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID9+4cvvVu5SOVi1/rxU6xhUcBAhW9frDaE0TI5MXrIX carson@toaster"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFzh/HEQgeasLpvfHLPSqDNpxjFwMdTIRjZoLkfKDm8x carson@surface"
  ];

  allKeys = hosts ++ carsons;

  moduleSecrets = map (path: {
    name = path;
    value.publicKeys = allKeys;
  }) (filter isAge (listFilesRecursive "modules" ./modules));
in
  listToAttrs moduleSecrets
