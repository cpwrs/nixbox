# TODO: Consider moving to agenix-rekey to avoid this
let
  inherit
    (builtins)
    attrNames
    attrValues
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

  keys = (import ./modules/keys.nix {}).flake.keys;

  allKeys = attrValues keys.hosts ++ attrValues keys.carsons;

  moduleSecrets = map (path: {
    name = path;
    value.publicKeys = allKeys;
  }) (filter isAge (listFilesRecursive "modules" ./modules));
in
  listToAttrs moduleSecrets
