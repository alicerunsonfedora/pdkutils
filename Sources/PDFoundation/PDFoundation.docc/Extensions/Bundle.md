# ``PDFoundation/Bundle``

## Overview

Bundles are used to store information and resources that can be
transported into Playdate projects. Some frameworks like PDUIKit provide
their own bundles that contain necessary resources for them to function.

Bundles typically contain a manifest and a resources directory that
contains all the necessary assets.

## Bundle structure

A bundle consists of the following files and directories at minimum:
- `pdbundleinfo` contains the bundle's manifest (see
  <doc:Bundle#Bundle-manifests>).
- `Resources` contains the bundle's resources, such as fonts, images, and
  sounds.

The following shows a sample bundle:

```
GreatLakes.pdbundle/
    pdbundleinfo
    Resources/
        Images/
            Lakes.png
        Sounds/
            water.mp3
        Models/
            RushmoreLowPoly.model
```

### Bundle manifests

Bundle manifests are typically stored as a simple key-value pair in a text
file called `pdbundleinfo`. For the ``main`` bundle, the Playdate game's
`pdxinfo` is used instead.

```
name=Great Lakes
author=John Smith
bundleID=com.example.greatlakes
version=1.0
buildNumber=1
```

## Topics

### Available bundles

- ``main``

### Accessing bundle resources

- ``path(forResource:ofType:)``
- ``BundleResourceType``
- ``BundleAccessError``

### Standard bundle resources

- ``font(forResourceNamed:)``
- ``image(forResourceNamed:)``
