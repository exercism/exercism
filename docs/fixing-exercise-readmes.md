# Fixing Exercise READMEs

[x-common]: http://github.com/exercism/x-common/tree/master/exercises
[trackler]: https://github.com/exercism/trackler
[trackler-readme]: https://github.com/exercism/trackler/blob/master/lib/trackler/implementation.rb#L40-L42

READMEs are automatically generated in the [trackler][] gem, which is a
light-weight wrapper around all of the exercise data for all of the Exercism
tracks.

The README is assembled from:

* The basic description (found in the `description.md` in the directory named after the exercise's slug in [x-common][])
* The generic metadata (found in the `metadata.yml`, also in [x-common][])
* The track-wide hints file (found in the root of the language track repository.
  The file is named `SETUP.md`)
* The exercise-specific hints file (found in the track repository, within the
  directory containing the exercise implementation. The file is named
  `HINTS.md`)

In addition, there's some hard-coded, generic stuff that lives in the
[file that assembles the README][trackler-readme] within the trackler gem.
