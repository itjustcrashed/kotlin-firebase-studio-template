# idx-template.nix
# Accept additional arguments to this template corresponding to template
# parameter IDs, including default values (language=ts by default in this example).
{ pkgs, project-type ? "library", project-dsl ? "kotlin", project-tests ? "junit-juniper", project-name ? "myproject", project-package ? "com.example.myproject", ... }: {
  packages = [
    pkgs.jdk21
    pkgs.gradle
    pkgs.kotlin
  ];

  bootstrap = ''
    # We use Nix string interpolation to pass the user's chosen programming
    # language to our script.
    gradle init \
    --type ${project-type} \
    --dsl ${project-dsl} \
    --test-framework ${project-tests} \
    --package ${project-package} \
    --project-name ${project-name} \
    --use-defaults

    # Copy the folder containing the `idx-template` files to the final
    # project folder for the new workspace. ${./.} inserts the directory
    # of the checked-out Git folder containing this template.
    cp -rf ${./.} "$out"

    # Set some permissions
    chmod -R +w "$out"

    # Remove the template files themselves and any connection to the template's
    # Git repository
    rm -rf "$out/.git" "$out/idx-template".{nix,json}
  '';
}
