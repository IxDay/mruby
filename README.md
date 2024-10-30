# Custom MRuby for Scripting Adventures

Welcome to my custom MRuby build! After exploring various scripting options, I’ve crafted this tailored version of MRuby to meet a specific set of requirements for cross-platform, CLI-oriented scripting.

## Project Overview

This project emerged from a quest to find the perfect scripting tool ([see blog post][blog_post]):
cross-platform, with a rich set of CLI primitives, and lightweight. While many tools like Bash, Python, and Node.js came close, they all had drawbacks in terms of compatibility, size, or simplicity. MRuby proved to be the answer, offering:

1. **Cross-Platform Compatibility:** Ensuring the binary works consistently across different operating systems.
2. **CLI Primitives:** Support for robust CLI output, option parsing, and flexibility to handle complex arguments.
3. **Built-in HTTP and JSON/YAML Support:** Ability to make HTTP calls and parse JSON directly in scripts.
4. **Lightweight and Fast:** All-in-one executable without extra setup, and quick to run even complex scripts.

## Nice-to-Have Features

Beyond the essentials, the custom MRuby binary includes additional features that enhance the scripting experience:

- **Small Self-Contained Binary:** A lightweight package to keep installations simple, with no extra dependencies.
- **Support for Task Execution:** With the included [mrake][mrake] library, you can organize and manage complex task workflows, similar to Makefile dependencies.
- **Dynamic Language Power:** MRuby brings the expressiveness of Ruby while remaining efficient and portable.

## Installation and Getting Started

To get started, simply download the appropriate binary for your operating system from the [Releases](#releases) section.

After downloading:

1. **Run the binary**: Just execute it from your terminal, no installation required.
2. **Create your scripts**: Use MRuby’s flexible syntax and built-in modules to start scripting. Check out the [Examples](./examples) folder for sample scripts that demonstrate MRuby’s capabilities.

## Releases

Find the latest binaries on the [Releases page][releases]. Each release includes pre-packaged versions for different platforms (Linux, MacOS, Windows **coming soon**) so you can get up and running with minimal setup.)

## Roadmap

- Windows binary
- Better integration of PolarSSL to handle certificate generation


[mrake]: https://github.com/IxDay/mrake
[releases]: https://github.com/IxDay/mruby/releases
[blog_post]: https://platipy.notion.site/The-quest-for-the-optimal-scripting-language-b013b3e35a5c4c6c8d5b4a7a31cb1508
