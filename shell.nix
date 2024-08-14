with (import <nixpkgs> {});
mkShell {
  # From https://stackoverflow.com/questions/62287269/nix-shell-cannot-change-locale-warning
  LOCALE_ARCHIVE_2_27 = "${glibcLocales}/lib/locale/locale-archive";

  buildInputs = [
    hugo
  ];

  # shellHook = ''
  #     # Setup the virtual environment if it doesn't already exist.
  #     VENV=quarto-venv
  #     if test ! -d $VENV; then
  #       virtualenv $VENV
  #     fi
  #     source ./$VENV/bin/activate
  #   '';
}
