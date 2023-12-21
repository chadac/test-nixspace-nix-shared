{
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "deterministic-zip";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "timo-reymann";
    repo = "deterministic-zip";
    rev = version;
    hash = "sha256-G9N8fGbvYHjSiXz1GFVbuL821N7Lnk0cdBzgXkufCBw=";
  };

  vendorHash = "sha256-uarCXEeZsNc0qJK9Tukd5esa+3hCB45D3tS9XqkZ4hU=";
}
