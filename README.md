# vmf-tools-crystal

Command line utility to interact with VM Farms

## Installation

1. Install Crystal

   On Mac OS X with Homebrew:

   ```
   brew install crystal
   ```
1. Create a file to hold the access token at ~/.vmf.env:
    ```
    ACCESS_TOKEN=foo
    ```
1. Install dependencies:
    ```
    shards install
    ```
1. Build the binary by running `make build-release`
1. The binary is built as `./vmf-tools`

## Usage

To shell into a hostname:

```
./vmf-tools shell hostname
```

That will make an API request to `my.vmfarms.com` to get available servers, find the IP address for the hostname specified and invoke an ssh session for the deploy user to the IP address.

To see a list of all hostnames and their IP addresses:

```
./vmf-tools shell ?
```

## Contributing

1. Fork it (<https://github.com/nurey/vmf-tools-crystal/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Ilia Lobsanov](https://github.com/nurey) - creator and maintainer
