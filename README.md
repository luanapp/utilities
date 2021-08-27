[![License][license-shield]][license-url]

# Utilities
Repository with some utilities scripts written by me through time

## Linux Shell Scripts
### File chjava<span/>.sh
Gets all the JDKs localized in the ~/opt folder (or the one provided with the -o option)
### File parallel_curl<span/>.sh
Executes curls in parallel using [GNU Parallel][gnu-parallel-url].
It can read input from a file to perform the calls
### File sqs_send_cancel_message<span/>>.sh
Send a message to an AWS SQS. It receives an input file and creates a selection list of SQS addresses

## License
Distributed under Apache 2.0 license. See [License](LICENSE) for more information.

[license-shield]: https://img.shields.io/badge/License-Apache%202.0-blue.svg
[license-url]: https://opensource.org/licenses/Apache-2.0
[gnu-parallel-url]: https://www.gnu.org/software/parallel/
