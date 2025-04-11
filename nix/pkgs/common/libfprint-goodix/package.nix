{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, meson
, python3
, ninja
, gusb
, glib
, gobject-introspection
, cairo
, libgudev
, openssl
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
,
}:

stdenv.mkDerivation {
  pname = "libfprint-goodix";
  version = "1.94.1";
  outputs = [
    "out"
    "devdoc"
  ];

  src = fetchFromGitHub {
    owner = "Infinytum";
    repo = "libfprint";
    rev = "5e14af7f136265383ca27756455f00954eef5db1";
    hash = "sha256-MFhPsTF0oLUMJ9BIRZnSHj9VRwtHJxvWv0WT5zz7vDY=";
  };

  patches = [
    ./0001-Wno-incompatible-pointer-types.patch
    ./0002-remove-53xd-incompatible.patch
  ];

  postPatch = ''
    patchShebangs \
      tests/*.py \
      tests/*.sh
  '';

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
    gobject-introspection
  ];

  buildInputs = [
    gusb
    glib
    cairo
    libgudev
    openssl
  ];

  mesonFlags = [
    "-Dudev_rules_dir=${placeholder "out"}/lib/udev/rules.d"
    "-Ddrivers=goodixtls511,goodixtls52xd,goodixtls53xd"
    "-Dudev_hwdb_dir=${placeholder "out"}/lib/udev/hwdb.d"
  ];

  nativeInstallCheckInputs = [
    (python3.withPackages (p: with p; [ pygobject3 ]))
  ];

  # We need to run tests _after_ install so all the paths that get loaded are in
  # the right place.
  doCheck = false;

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    ninjaCheckPhase

    runHook postInstallCheck
  '';

  passthru.driverPath = "/lib";

  meta = {
    homepage = "https://fprint.freedesktop.org/";
    description = "Library designed to make it easy to add support for consumer fingerprint readers";
    license = lib.licenses.lgpl21Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ rickyelopez ];
  };
}
