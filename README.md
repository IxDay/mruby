# MRuby distribution for everyday scripting

This project aims to provide a fully-featured scripting platform for all operating systems in a single, small binary.

## Project Overview

The idea emerged from a quest to find the perfect scripting tool for my Golang
projects ([see blog post][blog_post]).
I was dissatisfied with using Make and the heavy reliance on bash scripts (hello `coreutils` compat issues!)
to handle all the essential tasks a software project requires. I ended up shipping the following requirements:

1. **Cross-Platform Compatibility:** Ensuring the binary works consistently across different operating systems.
2. **CLI Primitives:** The binary is built with support for optparse, glob patterns, and Windows path compatibility.
3. **Built-in HTTP/HTTPS and JSON/YAML Support:** Ability to make HTTP/HTTPS calls and parse JSON/YAML directly in scripts.
5. **Small Self-Contained Binary:** All-in-one executable without extra setup, with no additional dependencies.
6. **Support for Task Execution:** With the included [mrake][mrake] library, you can organize and manage complex task workflows, similar to Makefile dependencies.

## Getting started

Download the mrake and mruby binaries from the [Releases page][releases] and place them in a folder within your $PATH.
That’s it! You can now script using `#!/usr/bin/env mruby` or by creating a Rakefile.
You can check out the [examples](./examples) folder for sample scripts that demonstrate MRuby’s capabilities.

## Forking

If your project requires a different set of dependencies, feel free to fork this project.
After forking, add or remove any dependencies in the [build configuration][build_config] file,
then enable the [GitHub Action][github_action] to package your own release.

## Releases

Find the latest binaries on the [Releases page][releases]. Each release includes pre-packaged versions for different platforms (Linux, MacOS, Windows) so you can get up and running with minimal setup.)


## License
This project is released under the [MIT License][license], the same as the parent project, [mruby][mruby].

## Roadmap

- Better integration of PolarSSL to handle certificate generation


[mrake]: https://github.com/IxDay/mrake
[mruby]: https://github.com/mruby/mruby
[build_config]: ./build.rb
[github_action]: ./.github/workflows/release.yml
[releases]: https://github.com/IxDay/mruby/releases
[blog_post]: https://platipy.notion.site/The-quest-for-the-optimal-scripting-language-b013b3e35a5c4c6c8d5b4a7a31cb1508
[license]: ./LICENSE
